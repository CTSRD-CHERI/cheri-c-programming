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
pointer (on success) that:

| Requirement | Rationale |
|-------------|-----------|
| Is valid (i.e., with its tag bit set) | Pointer must be dereferenceable for memory accesses on return |
| Is unsealed | Pointer must be dereferenceable for memory access on return |
| Has bounds that permit access to the full requested range of the allocation | Full allocation must be accessible for memory access on return |
| Has bounds that do not permit access to any other current allocation, nor to allocator metadata, implementing non-aliasing spatial safety | Allow access only to the memory allocation itself, and not either allocator-internal state (enabling a long history of heap corruption attacks or the leakage of privileged capabilities) or other allocations (violating non-aliasing requirements for spatial safety) |
| Has permissions that allow data load, data store, capability load, and capability store | C/C++ expect that memory will not only be accessible for read and write, but also that pointers can be held in arbitrary heap memory.  While it is possible (and reasonable) to imagine heap allocators that return pointers without the ability to load or store capabilities, doing so with the general-purpose C/C++ allocators will break almost all extant software. |
| Be sufficiently aligned to allow capability loads and stores at relative offset 0 from the returned pointer | As with capability load and store positions, being unable to use pointers stored at pointer alignment within an alllocation will break almost all extant software. |

The allocator must:

| Requirement | Rationale |
|-------------|-----------|
| Pad below and above allocations such that, when precise bounds are not utilized, no other allocation is accessible within returned bounds | This is a corallary of the above requirement to set bounds to prevent access to allocator metadata and other allocations, non-aliasing in the presence of bounds imprecision requires padding so that accessible memory outside of the requested size cannot access disallowed data. |

The allocator should:

| Requirement | Rationale |
|-------------|-----------|
| Fill reachable memory within bounds with zeroes before returning a pointer to it | Prevent both uninitialized values and data remanence by deterministically overwriting data that may otherwise be residual from previous allocations or memory-allocator metadata. |

The allocator must select one of the following two choices for each memory allocation; different memory allocations may use different strategies (e.g., enabling precise bounds for smaller allocations, or imprecise ones for larger allocations, as well as other strategies):

| Requirement | Rationale |
|-------------|-----------|
| Provide precise bounds -- i.e., in which the lower bound is the lowest address of the returned allocation, and the upper bound is the highest address of the returned allocation plus one | Implement precise bounds, where achievable whtin the constraints of bounds imprecision, avoiding the use of padding while still allowing access to the full allocation. |
| Pad and/or align allocation such that the returned address is equal to the lower bound | Implement non-aliasing memory by passing allocations and setting bounds to include only the allocation and its padding. |

### Freeing memory

CHERI-aware allocators must ignore, or trap on, calls to `free()` if the
passed capability:

| Requirement | Rationale |
|-------------|-----------|
| Is invalid (i.e, with its tag bit unset) | Only valid pointers -- i.e., those that have not been corrupted or already freed can be accepted by `free(). |
| Is sealed | Sealed pointers reflect the imposition of other policies on the allocation; while allocators able to free selected sealed pointers are imaginable, the requirements laid out in this section are not sufficient to do so, and a conservative policy is selected for the C/C++ heap allocator. |
| Has address, bounds, or permissions that differ from those on the original capability returned by `malloc()`, `calloc()`, or `realloc()` | The requirement to free the original address arises from the C standard; requiring no changes to capability metadata is a conservative policy allows the allocator to make minimum assumptions about its own use of the pointer being freed.  This has potential implications if sub-object bounds are used, as a pointer that, for example, has its bounds reduced to cover only the first field of a structure may no longer be used to free the full structure.  In the future it may be desirable to loosen this requirement, but a conservative stance is currently selected. |

The allocator may:

| Requirement | Rationale |
|-------------|-----------|
| Implement fail-stop semantics if the call fails for one or more of the above reasons | Fail stop rather than potentially allow internal allocator state to be corrupted; this will also prevent entering potentially harmful undefined behaviour in the caller. |
| Disregard invalid `free()` requests, continuing execution | Ignore the improper request rather than potentially allow internal allocator state to be corrupted, enabling improved availability at the cost of potential memory leakage and entry of undefined states in the caller. |
| Implement diagnostic features such as logging, crash dumps, and so on when such usage a failure occurs | This design choice applies given either of the above choices, and is recommended to improve diagnostic capacity in the system. |

### Reallocating memory

The allocator must ignore, or trap on, calls to `realloc()` if the passed
capability:

| Requirement | Rationale |
|-------------|-----------|
| Violates any of the properties checked for in `free()` | In effect, reallocation is a request to free memory, and will typically be implemented by the same paths within the allocator. |

The allocator must:

| Requirement | Rationale |
|-------------|-----------|
| Return a capability with the same properties as those defined for `malloc()` | In effect, reallocation is a request to allocate new heap memory, and will typically be implemented by the same paths within the allocator. |

The allocator must not:

| Requirement | Rationale |
|-------------|-----------|
| Return a new pointer from `realloc()` that has an identical address to the passed argument but differs in its bounds or other metadata | This requirement arises from the observation that callers to `realloc()` will immediately compare the passed pointer to the returned one to establish whether the memory was reallocated or not.  If it was, it is frequently the case that they will use the passed pointer rather than the returned one, since they are assumed to be interchangeable.  With CHERI C/C++, pointer equality testing with the `==` operator compares only the address and not bounds or other metadata, and as a result a pointer with the prior bounds, rather than the new bounds, may frequently be used.  Rather than allowing this situation to occur, we require reallocation.  This tradeoff point appears to maximise compatibility at the cost of performance and memory overhead.  It may be that this requirement is weakened to "should not" in the future. |

The allocator should:

| Requirement | Rationale |
|-------------|-----------|
| Zero any newly accessible memory before returning a pointer to it, including any allocator metadata | As for `malloc()`. |

The allocator may:

| Requirement | Rationale |
|-------------|-----------|
| Implement fail-stop semantics if the call fails for one or more of the above reasons | As for `free()`. |
| Disregard invalid `free()` requests, continuing execution | As for `free()`. |
| Implement diagnostic features such as logging, crash dumps, and so on when such usage a failure occurs | As for `free()`. |
