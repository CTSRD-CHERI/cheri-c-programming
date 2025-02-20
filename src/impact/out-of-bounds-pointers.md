### Out-of-bounds pointers
<!--
\label{sec:oob}
-->

<!--
\note{I feel like this section wants a reference to CHERI Concentrate?}{nwf}
-->

ISO C permits pointers to go only one byte beyond their original
allocation, but widely used code sometimes constructs transient pointer
values that are further out of bounds.
For example, `for` loops iterating over an array may increment a pointer
into the array by the array entry size before performing an overflow check
that terminates the loop.
This temporarily constructs an out-of-bounds pointer without an out-of-bounds
dereference taking place.

<!--
\nwfnote{In the straightforward case, tho, that still results in the pointer
being only one past the end of its allocation, doesn't it?}
-->

To support this behavior, capabilities
can hold a range of out-of-bounds addresses while retaining a valid
tag, and CHERI-enabled hardware performs bounds checks only on pointer
use (i.e., dereference), not on pointer manipulation.  Dereferencing
an out-of-bounds pointer will raise a hardware exception (see
[Capability-related faults](capability-faults.md)).
However, an out-of-bounds pointer can be
dereferenced once it has been brought back in bounds, by adjusting the
address or supplying a suitable offset in the dereference.

There is, however, a limit to the range of out-of-bounds addresses a capability can hold.
The capability compression model exploits redundancy between the pointer's address and
its bounds to reduce memory overhead (see [CHERI
capabilities](../background/cheri-capabilities.html)).
However, when a pointer goes out of bounds, this redundancy is reduced, and at
some point the bounds can no longer be represented within the capability.
The architecture prohibits manipulations that would produce such
a capability.
Depending on the architecture and context, this may lead to the
tag being cleared, resulting in an invalid capability, or in an immediate
hardware exception being thrown.
Attempting to dereference the invalid capability will fail in the same
manner as a loss of pointer provenance validity (see [Pointer provenance
validity](pointer-provenance-validity.html)).<!--
\psnote{Comment on whether that should immediately trap instead?} -->
The range of out-of-bounds addresses permitted for a capability is
a function of the length of the bounded region and the number of bits used for bounds in the capability representation.
With 27 bits of the capability used for bounds, 64-bit
CHERI-RISC-V provide the following guarantees:

* A pointer is able to travel at least 1/4 the size of the object, or
  2 KiB (2<sup>*floor*(*bounds_bits*/2)-2</sup>), whichever is greater,
  above its upper bound.

* It is able to travel at least 1/8 the size of the object, or 1 KiB
  (2<sup>*floor*(*bounds_bits*/2)-3</sup>), whichever is greater, below
  its lower bound.

In general, programmers should not rely on support for arbitrary out-of-bounds
pointers.  Nevertheless, in practice, we have found that the CHERI capability
compression scheme supports almost all in-the-field out-of-bounds behavior in
widely used software such as FreeBSD, PostgreSQL, and WebKit.
