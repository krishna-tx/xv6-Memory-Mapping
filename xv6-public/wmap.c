#include "types.h"
#include "wmap.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"

uint wmap(uint addr, int length, int flags, int fd) {
    struct proc* proc = myproc();
    if(!proc) return FAILED;

    // check if virtual page for address is not already mapped
    pte_t *pte = walkpgdir(proc->pgdir, (void *)addr, 0);
    if(!pte) return FAILED;
    if((*pte & PTE_P) == 0) return FAILED; // virtual page is already mapped to a physical page

    // continue with lazy allocation
    struct lazy_mappings *mappings = proc->mappings;
    for(int i = 0; i < 16; i++) {
        if(mappings[i].length == 0) { // empty slot is found
            mappings[i].addr = addr;
            mappings[i].length = length;
            mappings[i].flags = flags;
        }
    }
    return addr;

    // check for MAP_ANONYMOUS flag
    // if((flags & MAP_ANONYMOUS) != 0) { // not file-backed
    // }
    // else { // file-backed
        
    // }
}