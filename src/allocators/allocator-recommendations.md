## Recommendation for allocator implementations

This section provides recommendations for the implementers of heap
allocators on CHERI-enabled systems.
There is also specific guidance on handling alignment and padding required to
take into account bounds imprecision in [Implications for memory-allocator
design](../apis/implications-for-memory-allocator-design.md).

### Allocating memory

In addition to implementing the conventational invariants ensuring the
mutually exclusive allocation of memory, CHERI-aware implementations of
`malloc()`, `calloc()`, and `posix_memalign()` must either return a capability
holding a `NULL` pointer (on failure), or a capability holding a non-`NULL`
pointer (on success) that :

 * Is valid (i.e., with its tag bit set)
 * Is unsealed
 * Has bounds that permit access to the full requested range of the allocation
 * Has bounds that do not permit access to any other current allocation, nor
   to allocator metadata, implementing non-aliasing spatial safety
 * Has permissions that allow data load, data store, capability load, and
   capability store
 * Be sufficiently aligned to allow capability loads and stores at relative
   offset 0 from the returned pointer

The allocator should:

 * Fill reachable memory within bounds with zeroes before returning a pointer
   to it

The allocator may:

 * Provide precise bounds -- i.e., in which the lower bound is the lowest
   address of the returned allocation, and the upper bound is the highest
   address of the returned allocation plus one

### Freeing memory

CHERI-aware allocators must ignore, or trap on, calls to `free()` if the
passed capability:

 * Is invalid (i.e, with its tag bit unset); or
 * Is sealed; or
 * Has address, bounds, or permissions that differ from those on the original
   capability returned by `malloc()`, `calloc()`, or `realloc()`

The allocator may:

 * Implement fail-stop semantics if the call fails for one or more of the
   above reasons.
 * Implement diagnostic features such as logging, crash dumps, and so on when
   such usage a failure occurs.

### Reallocating memory

The allocator must:

 * Fail a call to `realloc()` if the passed capability violates any of the
   properties checked for in `free()`.
 * Return a capability with the same properties as those defined for
   `malloc()`.

The allocator must not:

 * Return a new pointer from `realloc()` that has an identical address to the
   passed argument but differs in its bounds or other metadata.

The allocator should:

 * Zero any newly accessible memory before returning a pointer to it,
   including any allocator metadata.

The allocator may:

 * Implement fail-stop semantics if the call fails for the above reasons.
