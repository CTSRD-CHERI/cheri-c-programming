## Unions

A significant benefit to introducing strong spatial and temporal safety in the
C and C++ programming languages is to reduce the opportunity for *type
confusion*, in which two different views (aliases) on the same memory region
allow that memory to be interpreted in different ways.
A classic example of this in widespread memory-corruption attacks is to store
to a memory region via characters (e.g., provided by network input) and then
to cause the application to load from the region interpreting it as a pointer
(e.g., as a control-flow pointer) making it possible to substantially
manipulate software including by achieving arbitrary code execution.
By implementing non-aliasing protection, pointers to one allocation of memory
cannot be used to implement type confusion with another pointer from a past or
future allocation of that memory.

Unions, however, are a C-language feature that intentionally allows multiple
interpretions of the same memory even within a single allocation.
While the precise impact is specific to its use, it is frequently the case
that unions may be used to reduce memory overhead or implement object
orientation, allowing code to interpret regions of memory as (for example)
both an array of characters and a control-flow pointer, enabling common attack
patterns.

CHERI's underlying robustness to integer-pointer type confusion is valuable in
mitigating such potential vulnerabilities, but as this does not provide strong
type safety, nor prevent other types of type confusion, ultimately this is
mitigation against attack techniques, rather than elimination of
vulnerability.

**Advice to developers**: Avoiding the use of unions in C will avoid such
  situations arising, especially in programming environments where the memory
  savings from such techniques may have little impact.
  Where unions must be used, attention can be paid to the types of confusion
  that might arise, as well as robust programming techniques to avoid type
  confusion.

**Ongoing research**: While SRI/Cambridge do not have current research in this
  space, it is easy to imagine introducing static limitations on union use,
  which could be evaluated for their impact on C/C++ code corpora to establish
  how disruptive this limitation might be at scale.
