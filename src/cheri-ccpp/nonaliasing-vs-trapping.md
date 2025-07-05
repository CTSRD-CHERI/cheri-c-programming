## Non-aliasing vs. trapping for memory safety

The CHERI architecture accepts a number of tradeoffs for performance reasons,
including imprecise bounds for spatial safety (to reduce pointer-size growth),
and quarantining for temporal safety (to mitigate revocation overheads).
CHERI C/C++ therefore adopt the following definitions and approximations:

 * **Referential safety** guarantees that a corrupted or reinjected pointer
   will be non-dereferenceable.
   This protection is guaranteed from the point of mis-manipulation (e.g., a
   partial overwrite in memory, manipulation using an inappropriate arithmetic
   operation, an attempt to violate monotonicity) but an architectural
   exception is not guaranteed to take place until a dereference (e.g., a
   load, store, or jump) is attempted.

 * **Spatial safety** guarantees non-aliasing between allocations: A pointer
   returned for one allocation will throw an architectural exception rather
   than permit out-of-bounds access to memory associated with another
   allocation.
   However, it is not guaranteed to throw an architectural exception if an
   out-of-bounds access would not access memory associated with another
   allocation.
   For example, non-trapping access may be permitted to padding after the end
   of a heap allocation for larger allocation sizes, due to bounds
   imprecision.
   It is the responsibility of the allocator to ensure that any non-trapping
   out-of-bounds access is *safe*.

 * **Temporal safety** guarantees non-aliasing between freed and current
   allocations: A pointer returned to a previously freed allocation will throw
   an architectural exception rather than permit use of the memory after
   reallocation.
   However, it is not guaranteed to throw an architectural exception if a use
   after free occurs before reallocation of that memory.
   For example, non-trapping access may be permitted to memory immediately
   after a call to `free()` but prior to asynchronous revocation or a further
   call to `malloc()` that reallocates the sam memory.
   It is the responsibility of the allocator to ensure that any non-trapping
   use-after-free access is *safe*.

These practical design choices have some important implications, including:

 * **Security arguments** are often easier to make in the presence of
   fail-stop behavior.
   Immediate trapping on a bounds or temporal-safety violation may make it
   easier to understand that code does not then proceed to other insecure
   behavior.
   Allocator authors may therefore choose to avoid aligning and padding
   strategies that unnecessarily introduce bounds imprecision.
   However, these tradeoffs do not weaken a security argument based on
   deterministic non-aliasing as the security guarantee, which tolerate
   continued execution beyond undefined behavior caused by a exception-free
   memory-safety bug.

 * **Debugabbility** is greatest when software fails stop close to the point
   of a bug occurring.
   CHERI will frequently ease debugging by ensuring trapping when aliasing
   takes place, as well as in many other situations.
   Deferred architectural exceptions until the point of dererence (for
   referential safety), or the point of potential alising (for spatial and
   temporal safety) do not weaken current debuggability, but also may not
   improve it in some situations.
   This is especially true when working with large or non-aligned memory
   allocations (for spatial safety) or rapid use-after-free without
   reallocation (for temporal safety).
   These design choices differ from those made in, for example, LLVM's address
   sanitizer, where rapid exception throwing is weighted more greatly than
   security mitigation.
