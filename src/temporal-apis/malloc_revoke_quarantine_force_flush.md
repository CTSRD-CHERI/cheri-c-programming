### Forcing revocation of outstanding freed pointers

Revocation of freed pointers is normally deferred, with the memory placed in
quarantine, for performance reasons.
`malloc_revoke_quarantine_force_flush(3)` flushes the current quarantine,
performing two functions:

 1. It initiates revocation of all memory quarantined when the API is called.
 2. It acts as a barrier to ensure that all pointers to memory allocations
    freed prior to the API being called have been revoked.

There are no guarantees made for frees occuring concurrent to, or after, the
call is made.

Use of this API is discouraged: It is provided primarily for testing,
debugging, and demonstration purposes, and can come with a very high
performance overhead.
