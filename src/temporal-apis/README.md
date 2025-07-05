## C APIs relating to temporal safety

Some CHERI run-time environments implement heap temporal safety, including
CheriBSD's CheriABI process environment and CHERIoT RTOS.
As described in [Referential, spatial, and temporal
safety](../cheri-ccpp/referential-spatial-temporal-safety.md), this is done on
the basis of quaranting with deferred (amortized) revocation of pointers that
must be performed before corresponding memory can be reallocated.

For CheriABI, the
[malloc_revoke(3)](https://man.cheribsd.org/cgi-bin/man.cgi/malloc_revoke)
APIs allowing interacting with, and control of, heap revocation.
These APIs relate only to quarantining and revocation of memory
allocated by the system heap allocator, `malloc(3)`.
Other memory allocators, such as the system memory-map allocator, may
independently implement temporal safety regardless of the heap allocator's
own configuration.
At the time of writing, these APIs are present only in CheriBSD.
See that manual page for complete documentation on available APIs.

We briefly consider two APIs: `malloc_revoke_enabled(3)`, which tests for
temporal safety support being enabled, and
`malloc_revoke_quarantine_force_flush(3)`, which triggers revocation and acts
as a barrier on its completion.
