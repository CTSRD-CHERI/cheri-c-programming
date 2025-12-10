## Compile-time uncertainty on pointer types

CHERI C/C++ provide strong dynamic differentiation of pointer and integer
values by virtue of the capability tag, which prevents their confusion at run
time.
For example, C code intended to increment a pure integer type will clear the
tag on a previously valid pointer, preventing its future dereference.
However, there are some necessary situations in which there is ambiguity --
perhaps required by the language specification, or perhaps just idiomatic use
-- and either integer or pointer values must be loaded or stored.
These fall into two common cases: Capability-oblivious copying, and explicit
type ambiguity.

### Capability-oblivious memory copying

Memory-copying is both a explicit and implied in the C and C++ languages, and
also a construct that programmers can implement.

The C `memcpy()` API copies a fixed quantity of data from one memory location
to another.
In CHERI C/C++, `memcpy()` is capability-oblivious: It is not, in general,
possible to know whether the originating memory should or does contain
capabilities, or whether the destination should or can accept their storage.
For example, a pointer to a structure that does contain a pointer field could
be cast to `void *`, losing that information.
Similarly, a pointer to an array of integer types, and no pointer fields, could
be cast to `void *`, losing that information.
While a manual copy of fields might do so using variables that do (or do not)
preserve tagged values, `memcpy()` implementations must be *capability
oblivious*: They copy any capabilities present, preserving rather than
stripping tags.

The situation is further complicated by compiler optimizations that may either
inline or outline `memcpy()`.
For example, a large structure assignment may appear to be type aware,
generating a series of suitably typed loads and stores, preserving or
stripping tagged values as appropriate, but the compiler is permitted to
replace that sequence with a call to `memcpy()` that will preserve tags even
if the source or destination types would not permit it.

Finally, there are many APIs in C, common libraries, and applications that are
in fact `memcpy()` implementations that must similarly be oblivious to dynamic
enforcement for the same reason.
For example, `qsort()` might be used on structures that contain pointers, and
therefore must preserve pointer types.
This imposes both a compatibility burden (custom memory-copying routines
require adaptation to preserve pointers) and also in effect causes capability
values to be propagated even if the C types themselves would not generally
cause that to take place.

**Advice to developers**: In general, C APIs such as `memcpy()`, and in fact
  structure assignment statements, can be assumed to always preserve pointers
  when they need to, but may also preserve them when not expected to.
  If it is important to prevent propagation, use the
  `cheri_perms_and()` API to strip the `CHERI_PERM_LOAD_CAP` permission before
  passing it to a routine that may perform a memory copy.
  In the CheriBSD kernel, which frequently needs to limit the flow of
  capabilities, `memcpynocap()` exists as a wrapper to this.

**Ongoing research**: SRI/Cambridge are continuing our research into the
  effects of compiler optimisations and when to constrain optimisations to
  better enforce protection properties.
  However, the tradeoffs here are tricky given the pracical goal of minimizing
  source-code disruption.
  It may be useful to add a new `memcpy_nocap()` API usable by both userlevel
  and the kernel.

### Intentional integer-pointer type ambiguity

Sometimes, programmers require an integer type that can be used to hold both
integer and pointer values, and furher, require that pointer arithmetic
performed on that type result in a dereferenceable pointer.
This is typically performed using the types `intptr_t` and `uintptr_t`, which
will frequently be found in software such as language runtimes, but also in
code implementing *callbacks* or similar programming behaviors where arbitrary
arguments or return values must be passed around by code not aware of the true
data types being used.
Stripping the tag on values calculated via these types will seriously disrupt
realworld source code.
When these types are used in CHERI C/C++, there are two important implications
with programmer impact:

  1. Capability-sized storage will be allocated, rather than that of the
     largest integer type, which can be confusing; i.e., `sizeof(intptr_t)`
     is not the same as `sizeof(intmax_t)`.
     Further, if these types have been used extensively, perhaps in preference
     to other integer types, this can lead to a significant memory overhead
     beyond that seen just from increasing the size of pointer types.

  2. Instructions are therefore used that will preserve the tag on a
     capability dynamically by virtue of using arithetic instructions normally
     used only for pointer types.
     However, this means that CHERI C/C++ are not able to provide certain
     types of dynamic integer-pointer type-confusion prevention, as the types
     are inherently ambiguous.

     For example, while with non-`intptr_t` integer types, the tag will always
     be cleared when its arithmetic operations are applied to a pointer, this
     is not true when `intptr_t` is used for integers.
     If `intptr_t` is used extensively for integer types (e.g., as the atom
     type in a language runtime), then the opportunity for dynamic confusion
     is restored: arithmetic operations intended only to operate on integer
     values will also operate on pointers preserving the tag.

It is worth further noting that the C types `long` and `unsigned long` have
historically been used for these purposes, although that has been discouraged
for many years.
Code using `long` and `unsigned long` to hold pointer values in CHERI C/C++
will not preserve tags, and hence casting a pointer via `long` or `unsigned
long` will lead to the pointer no longer being dereferenceable.

**Advice to developers**: `intptr_t` and `uintptr_t` should be used only where
  essential to achieving the programming goals of either holding a pointer or
  integer in the same type (perhaps as an opaque argument), or to enable more
  rich forms of arithmetic on pointers.
  Where programers wish to compute on the address of pointers without provenance, `ptraddr_t` should be used to make this clear.
  Pointers can be unambiguously reconstructed using `ptraddr_t` computations and `cheri_address_set()`.
  `ptraddr_t` is currently under consideration for standardization as paper [P3744R0](https://isocpp.org/files/papers/P3744R0.html).
  `long` and `unsigned long` should never be used to hold pointers that must
  remain deferenceable.

**Advice to developers**: `ptraddr_t` should be used in place of `long`,
`unsigned long` or `uint64_t` where an integer type is required to hold
a virtual address.
As [previously introduced](../impact/recommended-use-c-types.md), `ptraddr_t`
is not dereferenceable on CHERI, and must be combined with a valid capability
to generate a dereferenceable pointer.
