### malloc_revoke_enabled(3)

Heap allocator use of revocation is configurable by process.
If it is enabled in the current process, `malloc_revoke_enabled(3)` will
return true; otherwise, it will return false.
