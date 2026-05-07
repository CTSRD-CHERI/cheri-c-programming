# Heap memory allocators and CHERI C/C++

This chapter considers two closely related topics:

 * **Guarantees** that may be relied on by developers of CHERI C/C++ software
   that makes use of heap allocators; and
 * **Recommendations** for heap memory-allocator developers targeting CHERI
   C/C++ execution environments.

While the focus of this section is on classical C-language APIs for heap
allocation, such as `malloc()`, `calloc()`, `free()`, and `realloc()`,
aspects of these guidelines will also apply to many other allocators
including, to varying extents, bespoke allocators in OS kernels, language
runtimes, and scalable applications.

## Changes to memory allocators to enable support for CHERI

The essential behaviors of current allocators are not changed with
CHERI: Allocators are responsible for returning pointers to memory storage
that is, under allocator invariants, stable and unique for the lifetime of the
allocation.
However, allocator implementations must be adapted to CHERI C/C++ in order to
implement memory-safety properties such as spatial and temporal safety.

To achieve memory protection for callers, allocators must:

 * Align and pad allocations to take into requirements for capability
   alignment and bounds imprecision;
 * Set CHERI capability properties (such as bounds) on returned pointers; and
 * Implement support for revocation after `free()`.

CHERI will then ensure that memory accesses to allocations made via pointers
are safe with respect to memory-safety properties such as spatial safety,
temporal safety, and so on.
How CHERI achieves these goals is discussed in greater detail in [Non-aliasing
vs. trapping for memory safety](../cheri-ccpp/nonaliasing-vs-trapping.md).

## Caller expectations and implementation guidance

It is important to consider both what expectations a programmer may have when
using a heap allocator with CHERI (e.g., what is the scope of reasonable
expected bounds that might be set on an allocation) as well as what behaviors
the programmer must conform to (e.g., not attempting to free untagged pointer
values).
Further, beyond API requirements, we also describe expectations for
heap-allocator implementations, especially around aspects of temporal safety.
