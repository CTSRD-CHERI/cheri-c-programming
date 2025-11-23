## Bounds imprecision, sub-object bounds, and custom allocators

CHERI capabilities employ bounds compression to fit both the lower and upper
bounds into a single address-sized word of metadata.
See (Bounds precision)[../background/cheri-capabilities.html#bounds-precision]
for further details.

As a result, it is not possible to represent all possible combinations of
lower and upper bounds with a given address, leading to stronger alignment and
padding requirements for memory allocations.
The compiler, linker, and run-time environment are aware of these constraints,
and hence generally introduce necessary alignment and padding as required --
for example, by placing additional padding around some memory allocations to
ensure that more coarse bounds do not allow underruns or overruns to access
memory associated with other allocations.
See (Bounds alignment due to compression)[../apis/bounds-alignment-due-to-compression.html#bounds-alignment-due-to-compression]
for further details.

There are, however, situations in which programmers must be explicitly aware
of this imprecise bounding behavior, including:

 - Optional use of sub-object bounds, which are currently considered
   *opportunistic protection* as they do not adjust structure alignment and
   padding for fields.
   This feaure is not currently enabled by default in the compiler.

 - Application-specific memory allocators, which require modest extensions to
   not just set bounds, but also ensure suitable alignment and padding such
   that non-aliasing can be enforced using CHERI bounds.

 - Other uses of manually set bounds in libraries and applications to limit
   the potential for underruns and overruns, such as in packet parsing, which
   must similarly take into account new alignment and padding requirements.

Where possible, the compiler will emit warnings in situations where sub-object
bounds cannot be guaranteed to provide precise spatial protection.

**Advice to developers**: When using sub-object bounds, additional padding and
  alignment may be required to ensure precise protection.
  In some situations, it may be more efficient to use external allocations
  pointed to by a primary allocation rather than embed sub-objects with large
  sizes and poor alignment within a larger strucure.
  Compiler warnings about limited precision should be observed.
  When implementing protecion in memory allocators, guidance provided in this
  document should be observed to ensure precise spatial safety is achieved.

**Ongoing research**: SRI/Cambridge have ongoing research to improve the
  safety of sub-object bounds in the hopes of transitioning them from being
  "opportunistic" to being deterministically safe.
  This involves improvements to compiler analysis, the use of trapping
  bounds-setting instructions to ensure fail-closedd behavior, and optional
  support for additional alignment and padding.
