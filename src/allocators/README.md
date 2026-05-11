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

It is important to consider both what expectations a programmer may have when
using a heap allocator with CHERI (e.g., what is the scope of reasonable
expected bounds that might be set on an allocation) as well as what behaviors
the programmer must conform to (e.g., not attempting to free untagged pointer
values).
Further, beyond API requirements, we also describe expectations for
heap-allocator implementations, especially around aspects of temporal safety.
