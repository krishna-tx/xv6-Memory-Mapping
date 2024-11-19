#include "types.h"
#include "wmap.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "memlayout.h"

uint wmap(uint addr, int length, int flags, int fd) {
    struct proc* proc = myproc();
    if(!proc) return FAILED; // myproc() failed

    // check if each virtual page in the address range is not already mapped to a physical page
    uint curr_addr = addr;
    pte_t *pte;
    while(curr_addr < addr + length) {
        pte = walkpgdir(proc->pgdir, (void *)curr_addr, 0);
        if(pte != 0) return FAILED; // pte for the vpn contains a ppn (already mapped)
        curr_addr += PGSIZE;
    }    

    // continue with lazy allocation
    struct wmappings *mappings = &proc->mappings;
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
        if(mappings->length[i] == 0) { // empty slot is found
            mappings->total_mmaps++;
            mappings->addr[i] = addr;
            mappings->length[i] = length;
            mappings->n_loaded_pages[i] = 0;
            mappings->flags[i] = flags;
            mappings->fd[i] = fd;
        }
    }
    return addr;

    // check for MAP_ANONYMOUS flag
    // if((flags & MAP_ANONYMOUS) != 0) { // not file-backed
    // }
    // else { // file-backed
        
    // }
}

int wunmap(uint addr) {
    struct proc* proc = myproc();
    if(!proc) return FAILED; // myproc() failed
    struct wmappings *mappings = &proc->mappings;
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
        if(mappings->addr[i] == addr) { // mapping found
            // check if each virtual page in the address range is not already mapped to a physical page
            uint curr_addr = addr;
            int length = mappings->length[i];
            pte_t *pte;
            while(curr_addr < addr + length) {
                pte = walkpgdir(proc->pgdir, (void *)curr_addr, 0);
                if(pte == 0) { // no mapping yet
                    curr_addr += PGSIZE;
                    continue;
                }
                uint physical_addr = PTE_ADDR(*pte); // get physical addr of page
                kfree(P2V(physical_addr)); // free physical page
                *pte = 0; // clear the pte
                curr_addr += PGSIZE;
            }

            // TODO: check for MAP_SHARED flag

            // clear values in mappings
            mappings->total_mmaps--;
            mappings->addr[i] = 0;
            mappings->length[i] = 0;
            mappings->n_loaded_pages[i] = 0;
            mappings->flags[i] = 0;
            mappings->fd[i] = 0;
            break;
        }
    }
    return SUCCESS;
}

uint va2pa(uint va) {
    struct proc* proc = myproc();
    if(!proc) return FAILED; // myproc() failed
    pte_t *pte = walkpgdir(proc->pgdir, (void *)va, 0);
    if(pte == 0) return FAILED; // no mapping yet

    uint physical_addr = PTE_ADDR(*pte); // get physical addr of page

    uint offset = va & (1 << 12 - 1);
    return physical_addr + offset;
}

int getwmapinfo(struct wmapinfo *wminfo) {
    struct proc* proc = myproc();
    if(!proc) return FAILED; // myproc() failed
    struct wmappings *mappings = &proc->mappings;
    wminfo->total_mmaps = mappings->total_mmaps;
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
        wminfo->addr[i] = mappings->addr[i];
        wminfo->length[i] = mappings->length[i];
        wminfo->n_loaded_pages[i] = mappings->n_loaded_pages[i];
    }
    return SUCCESS;
}