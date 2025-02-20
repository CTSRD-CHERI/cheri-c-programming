## POSIX API changes

* **Writing and reading pointers via files**: In the CheriABI process
  environment, only untagged data (not tagged pointers) may be written to or
  read from files.
  If a region of memory containing valid pointers is written to a file, and
  then read back, the pointers in that region will no longer be valid.
  If a file is memory mapped, then pages mapped copy-on-write
  (`MAP_PRIVATE`) are able to hold tagged pointers, since they are
  swap-backed rather than file-backed, but pages mapped directly from the
  buffer cache (`MAP_SHARED`) are not.

* **Passing pointers via IPC**: In the CheriABI process environment, only
  untagged data, not tagged pointers, may be passed via various forms of
  message-passing Inter-Process Communication (IPC).
  Some existing software takes advantage of a shared address-space layout
  (via `fork`) to pass pointers to elements of shared data structures
  (e.g., entries in dispatch tables).
  This code must be converted to use indexes into tables or other lookup
  mechanisms rather than passing pointers via IPC.

* **`mmap` bounds**: In CheriABI, the `mmap` system
   call returns a bounded capability to the allocated address space.
   To ensure the capability does not overlap other allocations,
   lengths that would otherwise be unrepresentable are rounded up
   and padded with a new type of guard pages.
   These guard pages fault on access and may not be mapped over.
   They are unmapped when the rest of the mapping is unmapped.

* **`mmap` permissions**: The permissions of the capability
   returned by `mmap` are determined by a combination of the
   requested page protections and the capability passed as an address hint
   (or fixed address with `MAP_FIXED`).
   When using the pattern of requesting a mapping with `PROT_NONE`
   and then filling in sections (as is done in run-time linkers, VM host
   environments, etc), it is necessary to ensure that the initial
   capability has the right permissions.
   The `prot` argument has been extended to accept additional
   flags indicating the maximum permission the page can have so that a
   linker might request a reservation for a library with the permissions
   `(PROT_MAX(PROT_READ|PROT_WRITE|PROT_EXEC) | PROT_NONE)`, which
   would return a capability permitting loads, stores, and instruction
   fetch while mapping the pages with no (MMU) permissions.
