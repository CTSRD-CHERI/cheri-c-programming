## Integer-pointer safety vs. pointer type safety

CHERI C/C++ provide strong, dynamic differentiation of integer and pointer
values by virtue of capability tags: Integer values are not architecturally
dereferenceable.
CHERI C/C++ also strongly differentiate executable pointers (which will be
sealed and have execute permission) from data pointers (which will have load
and store permissions), which prevents execution of data as well as pointer
arithmetic on control-flow pointers.

However, tagged capabilities do not dynamically enforce C/C++-language types.
For example, casting from `struct foo *` to `struct bar *` is permitted
dynamically as long as the compiler accepts the cast, regardless of whether
that leads to unintended type confusion.
This is required because idiomatic C/C++ software has a strong expectation for
flexible casting, and enforcing these types breaks a significant proportion of
real-world software.

Common usage patterns requiring this sort of cast include object-oriented
programming styles used in C, and it is not clear what dynamic type system
might be both strong enough to provide useful vulnerability mitigation while
also being flexible enough to accept most software.
In C++, there are well defined rules for casting between classes and
subclasses, but those rules are extremely flexible and are not easily or
efficiently implemented architecturally.

CHERI permissions to prevent certain very narrow types of dynamic type
confusion that are essential to low-level memory safety: Specifically,
CHERI-enabled kernels and run-time linkers will by invariant prevent the
creation of code pointers with store privilege, or data pointers with execute
privilege.
Sealed capabilities also prevent undesired mutation of code pointers outside
of run-time linkers, just-in-time compilers, or the dynamic creation of
return addresses during function calls.

As such, while CHERI C/C++ preventing integer-pointer type, as well as certain
narrow forms of pointer-pointer type confusion, is incredibly valuable in
implementing memory safety, its benefits should not be confused with those of
full dynamic type safety.

**Advice to developers**: While many integer-pointer type confusions are
  strongly prevented in CHERI C/C++, pointer-pointer type confusions other
  than between code and data are not prevented.
  Given the current absence of static analysis tools addressing this problem,
  the best recourse will be defensive programming styles that avoid the
  opportunity for pointer-pointer type confusion, and careful tagging and
  checking of invariants dynamically.

**Ongoing research**: SRI/Cambridge have been exploring dynamic enforcement
  of language-level types using the architectural *otype* feature, but have
  yet to find a satisfactory middle ground between idiomatic type flexibility
  and strong vulnerability mitigation.
  Frequently, type errors of interest in C++ involve complex class hierarchies
  and inheritence, which are not directly mappable into a flat type space.
  New types of dynamic type enforcement, using *otype* or other capability 
  features, seem a promising area to explore in the future.

  In the CHERIoT design, sealing is frequently used for type safety between
  compartments to allow compartment state to be efficiently referenced without
  connoting access to that state, which was one of the fundamental design aims
  of the capability *otype* mechanism.
  This is driven via direct use of types in the source code, rather than being
  an automatic compiler feature.
  Similarly, we have used sealing in earlier explorations of how vtables in
  language runtimes (e.g., Java runtimes) can be used to improve robustness
  through explicit use of the *otype* mechanism.
