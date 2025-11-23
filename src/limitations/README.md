# Constraints and limitations to memory safety

The idea of memory-safe C and C++, despite research exploration for several
decades, remains surprising: Both languages have long histories of
catatrophic memory-safety vulnerabilities, leading to unfortunate reputations
for their non-safety.
It is our experience in developing CHERI C and C++ that there are indeed
fundamental limits to the nature of improvements that can be made: Software
written in C and C++ expects significant type-system flexibility, making many
forms of static and dynamic enforcement difficult, and inherently embeds
assumptions that lead rapidly to "type confusion," a historically exploitable
condition.
However, it is also our practical experience that quite substantial headway
can be made in achieving strong memory safety for C and C++ despite this.

In this section we document and explore a number of constraints and
limitations to CHERI C and C++ memory safety.
Some originate from gaps between CHERI's capability model and language-level
notions of type safety (e.g., preventing integer-pointer confusion while not
introducting dynamic typing to differentiate pointer types from one another),
others from CHERI's performance and memory overhead(such as bounds
compression), and others from limitations of the currently implementations --
especially of the compiler -- that we hope further engineering will rectify.
These include:

 * Integer-pointer safety vs. true pointer type safety
 * Compile-time uncertainty on regarding pointer types
 * Bounds imprecision, sub-object bounds, and custom allocators
 * Unions
 * Stack temporal safety
 * Compiler optimizations and undefined behavior

For each issue, we provide advice to developers and, where applicable,
information on current research directions that may address these issues in
the future.
