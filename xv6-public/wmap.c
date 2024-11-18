#include "types.h"
#include "wmap.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"

uint wmap(uint addr, int length, int flags, int fd) {
    struct proc* proc = myproc();
    if(!proc) return FAILED; // myproc() failed

    // check if virtual pages for the address range are not already mapped to physical pages
    uint curr_addr = addr;
    pte_t *pte;
    while(curr_addr < addr + length) {
        pte = walkpgdir(proc->pgdir, (void *)curr_addr, 0);
        if(pte != 0) return FAILED; // pte for the vpn contains a ppn (already mapped)
        curr_addr += PGSIZE;
    }    

    // continue with lazy allocation
    struct wmapinfo *mappings = proc->mappings;
    for(int i = 0; i < MAX_WMMAP_INFO; i++) {
        if(mappings->length[i] == 0) { // empty slot is found
            mappings->total_mmaps++;
            mappings->addr[i] = addr;
            mappings->length[i] = length;
        }
    }
    return addr;

    // check for MAP_ANONYMOUS flag
    // if((flags & MAP_ANONYMOUS) != 0) { // not file-backed
    // }
    // else { // file-backed
        
    // }
}