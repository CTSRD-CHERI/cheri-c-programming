## Bitwise operations on capability types

In most cases bitwise operations &mdash; such as those used to store or clear flags
in the lower bits of pointers to well-aligned allocations &mdash; will result in the expected `uintptr_t` value being created.
However, there are some corner cases where the result may be a tagged (but out-of-bounds)
capability when an integer value is expected. <!--
\arnote{TODO: add an example. Maybe the mutex example checking low pointer bits + some alignment checks?}
-->
Dually, bitwise operations may also result in the loss of tags if intermediate results become unrepresentable (recall [Out-of-bounds pointers](out-of-bounds-pointers.html)).[^7]

Most bitwise operations on `uintptr_t` fall into one of three categories for which we provide
higher-level abstractions.

**Aligning pointer values**:
If the C code is attempting to align a pointer or check the alignment of pointers,
the following compiler builtins should be used instead:

* **`T __builtin_align_down(T ptr, size_t alignment)`**:
  This builtin returns `ptr` rounded down to the next multiple of `alignment`.
* **`T __builtin_align_up(T ptr, size_t alignment)`**:
  This builtin returns `ptr` rounded up to the next multiple of `alignment`.
* **`_Bool __builtin_is_aligned(T ptr, size_t alignment)`**:
  This builtin returns `true` if `ptr` is aligned to at least `alignment` bytes.

<!--
\rwnote{It would be nice if we had, and could document here, `cheri_` versions
  of these macros.}
\arnote{Probably best to use the `__builtin` versions since that also works for upstream clang.}
-->

One advantage of these builtins compared to `intptr_t` arithmetic is that they preserve the
type of the argument and can therefore remove the need for intermediate casts to `uintptr_t`.
Moreover, using these builtins allows for improved compiler diagnostics and can result in better code-generation compared to hand-written functions or macros.
We have submitted these builtins as part of the upstream Clang 10.0 release, so they can also be used for code that does not depend on CHERI.

<!--
\arnote{Should I include some of the documentation I wrote for upstream LLVM? (\url{https://clang.llvm.org/docs/LanguageExtensions.html\#alignment-builtins})}
-->

**Storing additional data in pointers**: <!--
\label{sec:low-pointer-bits}
-->
In many cases the minimum alignment of pointer values is known and therefore
programmers assume that the low bits (which will always be zero) can be
used to store additional data.[^8]
Unused high pointer bits cannot be used for additional metadata since toggling them causes a large change to the address field, and capabilities that are significantly far out-of-bounds cannot be represented (see
[Out-of-bounds pointers](out-of-bounds-pointers.html)).

The compiler-provided header `<cheri.h>` provides explicit macros for this
use of bitwise arithmetic on pointers.
The use of these macros is currently optional,[^9]
but we believe that they can improve readability compared to hand-written bitwise operations.
Additionally, the bitwise-AND operation is ambiguous since it can be used both to clear bits (which should return a provenance-carrying `uintptr_t`) and to check bits (which should return an integer value).
In complex nested expressions, these macros can avoid ambiguous provenance sources (see [Ambiguous provenance](../compiler/ambiguous-provenance.html)) since it shows the compiler which intermediate results can carry provenance.

* **`uintptr_t cheri_low_bits_clear(uintptr_t ptr, ptraddr_t mask)`**:
  This function clears the low bits of `ptr` in the same way as `ptr & ~mask`.
  It returns a new `uintptr_t` value that can be used for memory accesses when cast to a pointer.
  `mask` should be a bitwise-AND mask less than `_Alignof(ptr)`.
* **`ptraddr_t cheri_low_bits_get(uintptr_t ptr, ptraddr_t mask)`**:
  This function returns the low bits of `ptr` in the same way as `ptr & mask`.
  It should be used instead of the raw bitwise operation since it can never return
  an unexpectedly tagged value.
  `mask` should be a bitwise-AND mask less than `_Alignof(ptr)`.
* **`uintptr_t cheri_low_bits_or(uintptr_t ptr, ptraddr_t bits)`**:
  This function performs a bitwise-OR of `ptr` with `bits`.
  In order to retain compatibility with a non-CHERI architecture, `bits` should be less than the known alignment of `ptr`.
* **`uintptr_t cheri_low_bits_set(uintptr_t ptr, ptraddr_t mask, ptraddr_t bits)`**:
  This function sets the low bits of `ptr` to `bits` by clearing the low bits in  `mask` first.

**Computing hash values**:
The compiler will also warn when operators such as modulus or shifts are used on
`uintptr_t`. This usually indicates that the pointer is being used as the input to a hash
function or similar computations.
In this case, the programmer should not be using `uintptr_t` but instead cast the pointer
to `ptraddr_t` and perform the arithmetic on this type instead.

[^7]: Previous versions of the compiler used the capability offset (address
minus base) instead of the address for arithmetic on `uintptr_t`.
This often resulted in unexpected results and therefore we switched to using
the address in `uintptr_t` arithmetic instead.
The old offset-based mode may be interesting for garbage collected C where
addresses are less useful and therefore it can still be enabled by
passing `-cheri-uintcap=offset`.
However, this may result in significantly reduced compatibility with legacy C code.

[^8]: CHERI actually provides many more usable bits than a conventional architecture.
In the current implementation of 128-bit CHERI, any bit between<!--
\psnote{inclusive?} --> the least
significant and the 9th least significant bit may be toggled without causing
the tag to be cleared in pointers that point to the beginning of an allocation (i.e., whose *offset* is zero).  <!--
\psnote{This is confusing &mdash; not clearing the tag isn't the same as not destroying part of the pointer data...} -->
If the pointer is strongly aligned, further bits may be toggled without clearing the tag.
<!--
\nwfnote{But the macros only permit the use of the bottom 5.  We should say that somewhere.}
-->

[^9]: Until recently, not using these macros could result in subtle bugs at run time since pointer equality comparisons included the tag bit in addition to the address.
