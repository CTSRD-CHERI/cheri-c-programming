## Integer-pointer safety vs. pointer type safety

CHERI C/C++ provide strong, dynamic differentiation of integer and pointer
values by virtue of capability tags: Integer values are not architecturally
redereferenceable.
CHERI C/C++ also strongly differentiate executable pointers (which will be
sealed and have execute permission) from data pointers (which will have load
and store permissions), which prevents execution of data as well as pointer
arithmetic on control-flow pointers.
However, they do not dynamically enforce C/C++-language types: For example,
casting from `struct foo *` to `struct bar *` is permitted dynamically as long
as the compiler accepts the cast.
This is because idiomatic C/C++ software has a strong expectation for flexible
casting, and enforcing these types breaks a significant proportion of
real-world software.

**Advice to developers**: While many integer-pointer type confusions are
  strongly prevented in CHERI C/C++, pointer-pointer type confusions are not.

**Ongoing research**: SRI/Cambridge have been exploring dynamic enforcement
  of language-level types using the *otype* feature, but have yet to find a
  satisfactory middle ground between idiomatic type flexibility and strong
  vulnerability mitigation.  Frequently, type errors of interest in C++
  involve complex class hierarchies and inheritence, which are not directly
  mappable into a flag type space.
  New types of dynamic type enforcement, using *otype* or other capability 
  features, seems a promising area to explore in the future.
