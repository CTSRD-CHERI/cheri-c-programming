## Implications for memory-allocator design

One use case of these APIs is high-performance applications that contain custom memory
allocators and wish to narrow the bounds of returned pointers.
Two kinds of modifications are typically required:

* **Changes to alignment to allow for capabilities and bounds**:
  Changes relating to alignment fall into two categories.
  First, those required to allow pointers to be stored within allocations,
  which requires that allocations be aligned to the pointer width (128 bits).
  Second, further alignment changes will be required to ensure that bounds can
  be represented precisely.
  This requires suitably aligning both the bottom and top bounds to exclude
  any other live allocations, as described in [Bounds alignment due to
  compression](bounds-alignment-due-to-compression.html).
<!--
\arnote{May want to switch order of sections?}
-->

* **Reaching allocation metadata on `free`**:
  It is often the case that allocators utilize the value of the pointer passed
  to their custom `free` function to locate corresponding metadata &mdash;
  for example, by always placing that metadata immediately before the
  allocation, which would be outside of the allocation's bounds.
  Therefore, some additional work may be required to derive a pointer to the
  allocation's metadata via another global capability, rather than the one
  that has been passed to `free`.

These two concerns may interact: When a custom allocator places metadata at
the beginning of the allocation, care must be taken that the resulting pointer
is still strongly aligned.
While porting programs to run on CHERI, we found multiple sub-allocators
that used 8 bytes of metadata after the result from `malloc`.
This causes the resulting pointer to no longer be sufficiently aligned to
store capabilities without faulting or stripping tag bits.
<!--
\nwfnote{Does CHERI ISAv7 still fault in any of these scenarios?}
-->

Note that it is also possible to use the above APIs to validate inputs to
`free`, which is useful when the consumer of `free` is, for example,
an untrusted compartment or a component of a web browser that might be
influenced by an attacker. In such cases, `free` should validate that the
passed-in capability is tagged, is in-bounds, and points to a legitimate,
still-allocated allocation.  For allocators engaged in revocation for temporal
safety, concurrent revocation opens the door to TOCTTOU races within
`free`; additional care must be taken to prevent a double-`free`
using a stale pointer from freeing an object allocated after revocation.
