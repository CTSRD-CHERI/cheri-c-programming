# Restrictions in capability locations in memory
<!--
\label{sec:restricted-capability-locations}
-->

CHERI C/C++ constrain how and where pointers can be stored in memory in two
ways:

* **Alignment**: CHERI's tags are associated with capability-aligned,
  capability-sized locations in physical memory.
  Because of this, all valid pointers must be stored at such locations,
  potentially disrupting code that may use other alignments.

  On the whole, for performance and atomicity reasons, pointers are strongly
  aligned even on non-tagged architectures &mdash; however, when C constructs such
  as `__packed` are used, unaligned pointers can arise, and will not
  work with CHERI.
  While the compiler and native allocators (stack, heap, ...) will
  provide sufficient alignment for capability-based pointers, custom
  allocators may align allocations to `sizeof(intmax_t)` rather than
  `alignof(maxalign_t)`.

* **Size**: CHERI capabilities are twice the size of an integer able to
  describe the full address space.
  On 64-bit systems, this means that CHERI pointers will have a width of 128
  bits &mdash; while maintaining the arithmetic properties of a 64-bit integer
  address.
  C code historically embeds assumptions about pointer size in a number of forms,
  all of which will need to be addressed when porting to CHERI,
  including:

  * Assuming that a pointer will fit into the largest integer type.
  * Assuming that the number of bits in a pointer type is the same
    as the number of bits indexing the address space it can refer to.
  * Assuming that the number of bits in a pointer type is the same as the
    number of bits suitable for use in performing bit-wise manipulations of
    pointer values.
  * Assuming that pointers must either be 32 or 64 bits.
  * Assuming that aligning to `sizeof(double)` is sufficient to store any type.
  * Assuming that high bits of the pointer address can be used for
  additional metadata. This is not true on CHERI since toggling high bits of a
  pointer can cause it to be so far out of bounds that it is no longer representable
  due to the compression of pointer bounds. However, it is still possible to use
  the low bits for additional metadata (see [Bitwise operations on capability types](bitwise-operations.html)).

<!--
  \rwnote{Should there be more things in this list?}
-->

These portability problems will typically be found due to hardware exceptions
thrown on attempted unaligned accesses of capability values
(see \Cref{sec:faults}).
However, they can also arise in the form of stripped tag bits, leading to
invalid capabilities that cannot be dereferenced, if, for example, pointer
values are copied into inappropriately aligned allocations.
