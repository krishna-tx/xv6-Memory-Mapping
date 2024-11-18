#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "wmap.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint sys_wmap(void) {
  uint addr;
  int length, flags, fd;
  if(argint(0, (int *)&addr) < 0) return FAILED; // argint failed
  if(argint(0, &length) < 0) return FAILED; // argint failed
  if(argint(0, &flags) < 0) return FAILED; // argint failed
  if(argint(0, &fd) < 0) return FAILED; // argint failed

  // check if addr is a multiple of page size and within [0x60000000, 0x80000000]
  if(addr % PGSIZE != 0) return FAILED;
  if(addr > KERNBASE || addr < KERNBASE - (1 << 29)) return FAILED;

  // check if length > 0
  if(length <= 0) return FAILED;

  // check if MAP_SHARED and MAP_FIXED are set
  if((flags & MAP_SHARED) == 0 || (flags & MAP_FIXED) == 0) return FAILED;

  return wmap(addr, length, flags, fd); // call wmap in wmap.c
  // return SUCCESS;
}
