## Guarantees to the allocator consumer

This section describes properties that consumers of heap allocators may
rely on from CHERI-enabled allocators in the CHERI C/C++ programming environment.
The rationales for most choices described in this section are explored in
greater detail in the section [Recommendation for allocator
implementations](allocator-recommendations.md).

### Allocating memory

Calls to `malloc()`, `calloc()`, and `posix_memalign()` will return either a capability holding a `NULL` pointer (on failure) or a capability holding a non-`NULL` pointer (on success) that:

 * Is valid (i.e., with its tag bit set)
 * Is unsealed
 * Has bounds that permit access to the full requested memory range of the
   allocation
 * Has bounds that do not permit access to any other current allocation, nor
   to allocator metadata (implementing non-aliasing spatial safety)
 * Has permissions that allow at least data load, data store, capability load, and
   capability store
 * In the case of an allocation that is at least the size of a pointer, has an address that is sufficiently aligned to allow capability loads and stores at suitable relative alignment

The allocator may:

 * Fill reachable memory within bounds with zeroes before returning a pointer
   to it
 * Provide precise bounds, with the lower bound being the bottom address of
   the allocation, and the upper bound being one byte above the top address of
   the allocation
 * Provide imprecise bounds, inserting padding below or above the allocation
 * Pad and/or align allocation such that the returned address is equal to the
   lower bound.

### Freeing memory

The caller must pass either a `NULL` pointer via a capability argument to
`free()`, or a non-`NULL` capability that:

 * Is valid (i.e., with its tag bit set)
 * Is unsealed
 * Has address, bounds, and permissions identical to those on the original
   capability returned by `malloc()`, `calloc()`, `posix_memalign()`, or `realloc()`

In the presence of temporal safety support, the allocator will not:

 * Reuse storage associated with the allocation until there are no outstanding
   valid capabilities that authorize access to the memory

The allocator may:

 * Fill reachable memory within the bounds of the allocation with zeroes after
   it has been freed
 * On virtual-memory-enabled systems, unmap reachable memory within the bounds
   of the allocation after it has been freed
 * Revoke capabilities to the storage immediately upon free

If utilizing revocation, the allocator will:

 * Ensure that any outstanding capabilities to the allocation become
   non-dereferenceable before the memory can be reallocated

On revocation, the allocator may:

 * Clear the tag of revoked capabilities
 * Reduce the permissions on the revoked capabilities to deny further use

### Reallocating memory

The caller must not:

 * Pass a capability to `realloc()` that violates any of the requirements for
    a call to `free()`.

The allocator will:

 * Conform to the guarantees associated with calls to `malloc()`,
   `calloc()`, and `posix_memalign(), when allocating memory in
   `realloc()`.

The allocator will not:

 * Return a new pointer from `realloc()` that has an identical address to the
   passed argument but differs in its bounds or other metadata.

The allocator may:

 * Zero any newly accessible memory before returning a pointer to it.
 * Always reallocate, returning a new pointer, on every call to `realloc()`[^1].

[^1]: This is not an advisable strategy in the general case due to the potentiallly very high performance overhead that could be experienced with some idiomatic uses of C.
