### Recommended use of C-language types
<!--
\label{sec:recommended-c-types}
-->

As confusion frequently arises about the most appropriate types to use for
integers, pointers, and pointer-related values, we make the following
recommendations:

* **`int_t`, `int32_t`, `long_t`, `int64_t`, ...**: These pure integer types
  should be used to hold integer values
  that will never be cast to a pointer type without first combining them with
  another pointer value &mdash; e.g., by using them as an array offset.
  Most integers in a C/C++-language program will be of these types.

* **`ptraddr_t`**: This is a new integer type introduced by CHERI C and should be
  used to hold addresses.
  `ptraddr_t` should not be directly cast to a pointer type for
  dereference; instead, it must be combined with an existing valid capability
  to the address space to generate a dereferenceable pointer.
  Typically, this is done using the `cheri_address_set(c, x)` function.

* **`size_t`, `ssize_t`**: These integer types should be used
  to hold the unsigned or signed lengths of regions of address space.
<!--
  \arnote{\sizet not necessary the same as unsigned `ptrdiff_t`.}
-->

* **`ptrdiff_t`**: This integer type describes the difference of indices
  between two pointers to elements of the same array, and should not be used
  for any other purpose.
  It can be added to a pointer to obtain a new pointer, but the result will
  be dereferenceable only if the address lies within the bounds of the
  pointer from which it was derived.

  <!--
  \note{Isn't that last sentence true of any combination?}{nwf}
  -->

  Less standards-compliant code sometimes uses `ptrdiff_t` when the
  programmer more likely meant `intptr_t` or (less commonly)
  `size_t`.
  When porting code, it is worthwhile to audit use of `ptrdiff_t`.

  <!--
  \note{Should we recommend that \sizet be used to hold lengths of
  allocations and \ptrdifft be used to talk about spans of
  address space (e.g., the offsets between two subobjects of an allocation)?  I feel
  like the recommendations here are not as concrete as I'd like.}{nwf}
  -->

* **`intptr_t`, `uintptr_t`**: These integer types should be
  used to hold values that may be valid pointers if cast back to a pointer
  type.
  When an `intptr_t` is assigned an integer value &mdash; e.g., due to
  constant initialization to an integer in the source &mdash; and the result is
  cast to a pointer type, the pointer will be invalid and hence
  non-dereferenceable.
  These types will be used in two cases: (1) Where there is uncertainty as to
  whether the value to be held will be an integer or a pointer &mdash; e.g., for an
  opaque argument to a callback function; or (2) Where it is more convenient
  to place a pointer value in an integer type for the purposes of arithmetic
  (which takes place on the capability's address and in units of bytes, as if
  the pointer had been cast to `char *`).

  The observable, integer range of a `uintptr_t` is the same as
  that of a `ptraddr_t` (or `ptrdiff_t` for `intptr_t`), despite the increased
  *alignment* and *storage* requirements.

* **`intmax_t`, `uintmax_t`**: According to the C standard, <!--
  \arnote{7.20.1.5 Greatest-width integer types}
  -->
  these integer types should be *capable of representing any value of any (unsigned) integer type*.
  In CHERI C/C++, they are not provenance-carrying and can represent the integer *range* of `uintptr_t`/`intptr_t`, but not the capability metadata or tag bit.
  As the observable value of `intptr_t`/`intptr_t` is the pointer address
  range, we believe this choice to be compatible with the C standard.

  Additionally, due to ABI constraints, it would be extremely difficult to change the width of these types from 64 to 129 bits.
  This is also true for other architectures such as x86: despite Clang and GCC supporting an `__int128` type, `intmax_t` remains 64 bits wide.

  We generally do not recommend use of these types in CHERI C/C++.
  However, the types may be useful in `printf` calls (using the `%j` format string width modifier) as the `inttypes.h` `PRI*` macros can be rather verbose.

* **`maxalign_t`**: This type is defined in C as *an object type whose alignment is the greatest fundamental alignment*
  and this includes capability types for CHERI C/C++.  <!--
  \arnote{C2x \S{}7.19.2} 
  % and in C++ as a \enquote{type whose alignment requirement is at least as great as that of every scalar type}\arnote{C++17 \S{}21.2.4p5}
  -->
  We found that some custom allocators use `sizeof(long double)` or `sizeof(uint64_t)` to align their return values.
  While this appears to work on most architectures, in CHERI C/C++ this must be changed to `alignof(maxalign_t)`.[^1]

* **`char *`, ...**: These pointer types are suitable for
  dereference, but in general <!--
  \psnote{that "in general" makes me wonder about the exceptions?}
  \arnote{The only exception I can think of is requiring `void *` due to bad API design (callback parameters, etc).}
  -->
  should not be cast to or from arbitrary integer
  values.
  Valid pointers are always derived from other valid pointers (including those cast to `intptr_t` or `uintptr_t`), and cannot be
  constructed using arbitrary integer arithmetic.

It is important to note that `uintptr_t` is no longer the same size as
`size_t`. This difference may require making some changes to
existing code to use the correct type depending on whether the variable
needs to be able store a pointer type. In cases where this is not obvious
(such as for a callback argument), we recommend the use of `uintptr_t`.
This ensures that provenance is maintained.

<!--
\pgnnote{The above section begs questions relating to what is the
  responsibility of programmers and what can be aided or managed by
  compilers.  Ideally, the latter would be preferable to requiring
  programmers to understand things are possibly beyond their so-called
  experience.}
-->

[^1]: It is important to use `alignof` instead of `sizeof` since many
common implementations, such as GCC and FreeBSD, define `maxalign_t` as a
`struct` and not a `union`.
