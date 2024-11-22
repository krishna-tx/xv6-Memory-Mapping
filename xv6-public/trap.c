#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "reference.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  // OUR MODS
  case T_PGFLT: // T_PGFLT = 14
    uint addr_fault = rcr2(); // get addr that caused page fault - not page aligned
    struct proc* proc = myproc();
    struct wmappings *mappings = &proc->mappings;
    int mapping_found = -1;
    if(addr_fault < KERNBASE - (1 << 29)) { // not in wmap heap range
      // check if cow necessary
      // if ref_count = 0 => map page
      char *page_addr = (char*)PGROUNDDOWN(addr_fault);
      pte_t *pte = walkpgdir(proc->pgdir, page_addr, 0); // TODO - check ret val of walkpgdir
      if(pte == 0 || (*pte & PTE_P) == 0) {
        cprintf("break 1\n");
        break;
      }
      uint physical_addr = PTE_ADDR(*pte);
      uint flags = PTE_FLAGS(*pte);
      if((flags & PTE_PW) == 0) {
        cprintf("Segmentation Fault\n");
        kill(proc->pid); // kill the process
        break;
      }
      
      char *mem = kalloc();
      flags |= PTE_W;
      if(reference_count[physical_addr / PGSIZE] > 0) {
        memmove(mem, (char*)page_addr, PGSIZE);        
        // mappages(proc->pgdir, (void *)page_addr, PGSIZE, V2P(mem), flags);
        // *pte = V2P(mem) | flags | PTE_P;
        // reference_count[physical_addr / PGSIZE]--;
        kfree(P2V(physical_addr)); // free physical page
      }
      else {
        memset(mem, 0, PGSIZE); // zero out the page
        // mappages(proc->pgdir, (void *)addr_fault, PGSIZE, V2P(mem), PTE_W | PTE_U); // map page
      }
      *pte = V2P(mem) | flags | PTE_P;
      lcr3(V2P(proc->pgdir)); // tlb flush pgdir
      reference_count[V2P(mem) / PGSIZE]++;
      /**
      char *mem = kalloc();
      memmove(mem, (char *)P2V(physical_addr), PGSIZE);
      
      // *pte = V2P(page_addr) | flags | PTE_W;
      // *pte = 0;
      *pte = V2P(mem) | flags | PTE_W | PTE_P;
      
      // reference_count[V2P(page_addr) / PGSIZE]++;

      // *pte = physical_addr | flags | PTE_P;
      
      // mappages(proc->pgdir, (void *)addr_fault, PGSIZE, V2P(mem), flags | PTE_W);

      // cprintf("break 6\n");
      */
      break;
    }
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
      if(mappings->length[i] > 0) { // a mapping exists
        if(addr_fault >= mappings->addr[i] && addr_fault < mappings->addr[i] + mappings->length[i]) { // corresponding mapping found
          mapping_found = 0;

          // perform mapping
          char *mem = kalloc();
          if((mappings->flags[i] & MAP_ANONYMOUS) != 0) { // not a file-backed mapping
            memset(mem, 0, PGSIZE); // zero out the page
          }
          else { // file-backed mapping
            struct file *file = proc->ofile[mappings->fd[i]];
            struct inode *inode = file->ip;
            int page_idx = (addr_fault - mappings->addr[i]) / PGSIZE;
            int offset = page_idx * PGSIZE;
            begin_op();
            ilock(inode);
            readi(inode, mem, offset, PGSIZE);
            iunlock(inode);
            end_op();
          }
          mappages(proc->pgdir, (void *)addr_fault, PGSIZE, V2P(mem), PTE_W | PTE_U); // map page
          lcr3(V2P(proc->pgdir)); // tlb flush cr3
          mappings->n_loaded_pages[i]++;
          break;
        }
      }
    }
    if(mapping_found == -1) {
      cprintf("Segmentation Fault\n");
      kill(proc->pid); // kill the process
    }
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
