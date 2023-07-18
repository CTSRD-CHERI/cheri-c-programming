# Bounds from the heap allocator

`malloc` will set bounds on pointers to new heap allocations.
In typical C use, this is not a problem, as programmers expect to access
addresses only within an allocation.

However, in some uses of C, there may be an expectation that memory access can
occur outside the allocation bounds of the pointer via which memory access
takes place.
For example, if an integer pointer difference `D` is taken between
pointers to two different allocations (`B` and `A`), and later
added to pointer `A`, the new pointer will have an address
within `B`, but permit access only to `A`.
This idiom is mostly likely to be found with non-trivial uses of `realloc` (e.g., cases where multiple pointers into a buffer allocated or reallocated by `realloc` need to be updated).
We note that the subtraction of two pointers from different
allocations is undefined behavior in ISO C, and risks mis-optimization from
breaking compiler alias analysis assumptions.
Further, *any* operation on the pointer passed to `realloc` is undefined upon
return.  Instead, we suggest that the programmer measure a pointer `P`'s
offset into an object `A` *prior to* `realloc` and derive new pointers
from the `realloc` result `B` and these offsets. (i.e., compute
*`B` + (`P` - `A`)* rather than
*`P` + (`B` - `A`)*).[^4]

[^4]: While it may seem that `A` remains available after `realloc`, our
revocation sweeps which enforce temporal safety may have atomically replaced
this with a non-pointer value.  The scalar value
*`D` = `P` - `A`* will naturally be preserved by revocation.
