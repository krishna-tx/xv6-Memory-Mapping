# xv6-Memory-Mapping

This project modifies the xv6 OS source code to add memory mapping functionality as detailed here: https://git.doit.wisc.edu/cdis/cs/courses/cs537/fall24/public/p5

## Modifications:
* new wmap() and wunmap() syscalls to create memory mappings in the heap space (along with filebacked mapping)
* COW (Copy On Write) when a process forks to copy memory mappings from parent process to child process (previously new mappings were created by default)
* modified trap handler to handle page faults due to invalid mappings or invalid page accesses
