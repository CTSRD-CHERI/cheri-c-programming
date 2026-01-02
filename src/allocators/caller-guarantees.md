## Guarantees to the allocator consumer

This section describes properties that consumers of memory allocators may
rely on from all CHERI-enabled allocators.

### Allocating memory

Calls to `malloc()` and `calloc() must return capabilities that:

 * Are valid (i.e., with its tag bit set)
 * Are unsealed
 * Have bounds that permit access to the full requested memory range of the
   allocation
 * Have bounds that do not permit access to any other current allocation, nor
   to allocator metadata, implementing non-aliasing spatial safety
 * Have permissions that allow data load, data store, capability load, and
   capability store
 * Are sufficiently aligned to allow capability loads and stores at relative
   offset 0 from the returned pointer

The allocator may:

 * Fill reachable memory within bounds with zeroes before returning a pointer
   to it
 * Provide precise bounds, with the lower bound being the bottom address of
   the allocation, and the upper bound being one byte above the top address of
   the allocation

### Freeing memory

The caller must not pass as an argument to `free()` a capability that:

 * Is invalid (i.e., without its tag bit set)
 * Is unsealed
 * Has bounds other than those on the original capability returned by
   `malloc()`, `calloc()`, or `realloc()`
 * Has permissions that differ from those on the original capability returned
   by `malloc()`, `calloc()`, or `realloc()`

The allocator must not:

 * Reuse storage associated with the allocation until there are no outstanding
   valid capabilities that authorize access to the memory

The allocator may:

 * Fill reachable memory within the bounds of the allocation with zeroes after
   it has been freed
 * On virtual-memory-enabled systems, unmap reachable memory within the bounds
   of the allocation after it has been freed.
 * Revoke capabilities to the storage immediately upon free

If utilizing revocation, the allocator must:

 * Ensure that any outstanding capabilities to the allocation become
   non-dereferenceable

On revocation, the allocator may:

 * Clear the tag of revoked capabilities

### Reallocating memory

The caller must not:

 * Pass a capability to `realloc()` that violates any of the requirements for
    a call to `free()`.

The allocator must:

 * Conform to the guarantees associated with calls to `malloc()` and
   `calloc()` when allocating memory in `realloc()`.

The allocator must not:

 * Return a new pointer from `realloc()` that has an identical address to the
   passed argument but differs in its bounds or other metadata.

The allocator may:

 * Zero any newly accessible memory before returning a pointer to it.
 * Always reallocate, returning a new pointer, on every call to `realloc()`.
