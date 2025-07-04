[CHERI C/C++ Programming Guide](cover/README.md)

- [Introduction](introduction/README.md)
  - [Definitions](introduction/definitions.md)
  - [Version history](introduction/history.md)
- [Background](background/README.md)
  - [CHERI capabilities](background/cheri-capabilities.md)
  - [Architectural rules for capability use](background/architectural-rules.md)
- [CHERI C/C++](cheri-ccpp/README.md)
  - [The CHERI C/C++ run-time environment](cheri-ccpp/cheri-runtime.md)
  - [Referential, spatial, and temporal safety](cheri-ccpp/referential-spatial-temporal-safety.md)
  - [Non-aliasing vs trapping memory safety](cheri-ccpp/nonaliasing-vs-trapping.md)
- [Impact on the C/C++ programming model](impact/README.md)
  - [Capability-related faults](impact/capability-faults.md)
  - [Pointer provenance validity](impact/pointer-provenance-validity.md)
    - [Recommended use of C-language types](impact/recommended-use-c-types.md)
    - [Capability alignment in memory](impact/capability-alignment-in-memory.md)
    - [Single-origin provenance](impact/single-origin-provenance.md)
  - [Bounds](impact/bounds.md)
    - [Bounds from the compiler and linker](impact/bounds-from-compiler.md)
    - [Bounds from the heap allocator](impact/bounds-from-heap-allocator.md)
    - [Subobject bounds](impact/subobject-bounds.md)
    - [Other sources of bounds](impact/other-sources-of-bounds.md)
    - [Out-of-bounds pointers](impact/out-of-bounds-pointers.md)
  - [Pointer comparison](impact/pointer-comparison.md)
  - [Implications of capability revocation for temporal safety](impact/revocation.md)
  - [Bitwise operations on capability types](impact/bitwise-operations.md)
  - [Function prototypes and calling conventions](impact/function-prototypes-and-calling-conventions.md)
  - [Data-structure and memory-allocation alignment](impact/data-structure-and-memory-allocation-alignment.md)
    - [Restrictions in capability locations in memory](impact/restrictions-in-capability-locations.md)
- [The CheriABI POSIX process environment](cheriabi/README.md)
  - [POSIX API changes](cheriabi/posix-api-changes.md)
  - [Handling capability-related signals](cheriabi/handling-capability-signals.md)
- [CHERI compiler warnings and errors](compiler/README.md)
  - [Loss of provenance](compiler/loss-of-provenance.md)
  - [Ambiguous provenance](compiler/ambiguous-provenance.md)
  - [Underaligned capabilities](compiler/underaligned-capabilities.md)
- [Printing capabilities from C](printf/README.md)
  - [Generating string representations of capabilities](printf/strfcap.md)
  - [Printing capabilities with the printf(3) API family](printf/printf.md)
- [C APIs to get and set capability properties](apis/README.md)
  - [CHERI-related header files](apis/cheri-related-header-files.md)
  - [Retrieving capability properties](apis/retrieving-capability-properties.md)
  - [Modifying or restricting capability properties](apis/modifying-or-restricting-capability-properties.md)
  - [Capability permissions](apis/capability-permissions.md)
  - [Bounds alignment due to compression](apis/bounds-alignment-due-to-compression.md)
  - [Implications for memory-allocator design](apis/implications-for-memory-allocator-design.md)
- [C APIs for temporal safety](temporal-apis/README.md)
  - [Checking whether heap revocation is
    enabled](temporal-apis/malloc_revoke_enabled.md)
  - [Forcing revocation of outstanding freed
    pointers](temporal-apis/malloc_revoke_quarantine_force_flush.md)
- [Further reading](reading/README.md)
- [Acknowledgements](acks/README.md)
