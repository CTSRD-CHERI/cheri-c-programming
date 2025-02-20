## Bounds

CHERI C/C++ pointers are implemented using capabilities that enforce lower and
upper bounds on access.
In the pure-capability run-time environment, those bounds are normally set to
the range of the memory allocation into which the pointer is intended to
point.
Because of capability compression, increased alignment requirements may apply
to larger allocations (see [Bounds alignment due to compression](../apis/bounds-alignment-due-to-compression.html)).

Bounds may be set on pointers returned by multiple system components including
the OS kernel, the run-time linker, compiler-generated code, system libraries,
and other utility functions.
As with violations of provenance validity, out-of-bounds accesses &mdash; including
load, store, and instruction fetch &mdash; trigger a hardware exception (see
[Capability-related faults](capability-faults.html)).
