# Bounds from the compiler and linker

The compiler will arrange that language-level pointers to stack allocations have suitable
bounds, and that the run-time linker will return bounded pointers to global
variables.
Bounds will typically be set based on an explicitly requested allocation size
(e.g., via the size passed to `alloca` or, for compiler-generated
code or linker-allocated memory, by the C type mechanism (e.g.,
`sizeof(foo)`), adjusted for precision requirements arising from
capability compression.
In some cases, such as with global variables allocated in multiple object
files, the actual size of the allocation may not be resolved until run time,
by the run-time linker.
These bounds will typically not cause observable changes in behavior &mdash; other than hardware exceptions when (accidentally) performing an out-of-bounds access.
