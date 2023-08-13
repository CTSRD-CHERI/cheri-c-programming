# Referential, spatial, and temporal safety

Pure-capability C/C++ introduces a number of new types of protection not
present in compilation to conventional architectures:

* **Referential safety** protects pointers (references) themselves.
  This includes *integrity* (corrupted pointers cannot be dereferenced)
  and *provenance validity* (only pointers derived from valid pointers
  via valid manipulations can be dereferenced).

  When pointers are implemented using architectural capabilities, CHERI's
  capability tags and provenance validity naturally provide this protection.

* **Spatial safety** ensures that pointers may be used only to access memory
  within bounds of their associated allocation; dually, manipulating an
  out-of-bounds pointer will not grant access to another allocation.

  This is accomplished by adapting various memory allocators, including the run-time
  linker for global variables, the stack allocator, and the heap allocator,
  to set the bounds on the capability implementing a pointer before returning
  it to the caller.
  Due to precision constraints on capability bounds, bounds on returned
  pointers may include additional padding, but will still not permit access to any
  other allocations (see [Bounds alignment due to
  compression](../apis/bounds-alignment-due-to-compression.html)).
  Monotonicity ensures that callers cannot later broaden the bounds to cover
  other allocations.

Referential safety and spatial safety are implemented in CheriBSD's
pure-capability CheriABI execution environment and for bare-metal in
CheriFreeRTOS and CHERI-RTEMS.

* **Temporal safety** prevents a pointer retained after the release of its
  underlying allocation from being used to access its memory if that memory
  has been reused for a fresh allocation (e.g., after a fresh pointer to that
  memory has been returned by a further call to `malloc` after the
  current pointer passed to `free`).

  Heap temporal safety is accomplished by preventing new pointers being
  returned to a previously allocated region of memory while any prior pointers
  to that memory persist in application-accessible memory.
  Memory will be held in *quarantine* until any prior pointers have
  been revoked; then the memory may be reallocated.
  Architectural capability tags and virtual memory allow intermittent
  *revocation sweeps* to accurately and efficiently locate and
  overwrite any capabilities implementing stale pointers.
  Spatial safety ensures that pointers cannot be used to reference other
  memory, including other freed memory.

Temporal safety is the object of ongoing experiments.
A prototype that guards *heap* allocations has been developed for
CheriABI on CheriBSD, but is not yet integrated with the main development
branch.
We currently have no plans to develop support for temporal memory safety in
CheriFreeRTOS and CHERI-RTEMS, both due to the complexity of the temporal
safety runtime, and also because of CHERI temporal safety's dependence on an
MMU for performance.
