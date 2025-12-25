# Memory allocators and CHERI C/C++

This chapter considers two closely related topics:

 * Guarantees that may be relied on by memory-allocator consumers programmed
   in CHERI C/C++
 * Guidance for memory-allocator developers targeting CHERI C/C++ execution
   environments

While the focus of this section is on class C-language APIs such as
`malloc()`, `calloc()`, `free()`, and `realloc()`, aspects of these guidelines
will also apply to many other allocators including, to varying extents,
bespoke allocators in OS kernels, language runtimes, and scalable
applications.

The most fundamental behaviors of current allocators are not changed with
CHERI: Allocators are responsible for returning pointers to memory storage
that is, under its invariants, stable and unique for the lifetime of the
allocation.
However, allocator implementations must be adapted to CHERI C/C++: To achieve
memory protection for its callers, it must set CHERI capability properties
(such as bounds), taking into account properties such as capability alignment
and bounds compression, as well as (if required) integrate support for
revocation.
CHERI will then ensure that memory accesses to allocations made via pointers
are safe with respect to memory-safety properties such as spatial safety,
temporal safety, and so on.
