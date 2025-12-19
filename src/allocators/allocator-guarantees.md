## Recommendation for allocator implementations

### Allocating memory

In addition to implementing the conventational invariants ensuring the
mutually exclusive allocation of memory, CHERI-aware implementations of
`malloc()` and `calloc()` must return a capability that has the following
properties:

 * Is valid (i.e., with its tag bit set)
 * Is unsealed
 * Has bounds that permit access to the full requested range of the allocation
 * Has bounds that do not permit access to any other current allocation,
   implementing non-aliasing spatial safety
 * Has permissions that allow data load, data store, capability load, and
   capability store
 * Be sufficiently aligned to allow capability loads and stores at relative
   offset 0 from the returned pointer

The allocator should:

 * Zero the allocation before returning a pointer to it

The allocator may:

 * Provide precise bounds -- i.e., in which the lower bound is the lowest
   address of the returned allocation, and the upper bound is the highest
   address of the returned allocation plus one

### Freeing memory

CHERI-aware allocators must ignore, or trap on, calls to `free()` if the
passed capability:

 * Is invalid (i.e, with its tag bit unset); or
 * Is sealed; or
 * Has bounds that have been changed from those returned by the allocator
   when the allocation was first made; or
 * Has permissions that disallow any of data load, data store, capability
   load, or capability store

The allocator may implement fail-stop semantics if the call fails for one or
more of the above reasons.

### Reallocating memory

The allocator must fail a call to `realloc()` if the passed capability
violates any of the properties checked for in `free()`.

The allocator may implement fail-stop semantics if the call fails for the
above reason.

Returned capabilites must have the same capability properties as those defined
for `malloc()`.

The allocator must not return a capability that:

 * Has the same integer address as the passed argument but different bounds
