# Pointer provenance validity
<!--
\label{sec:pointer_provenance_validity}
-->

CHERI C/C++ implement pointers using architectural
capabilities, rather than using conventional 32-bit or 64-bit integers.
This allows the provenance validity of language-level pointers to be
protected by the provenance properties of CHERI architectural capabilities:
only pointers implemented using valid capabilities can be dereferenced.
Other types that contain pointers, `uintptr_t` and `intptr_t`,
are similarly implemented
using architectural capabilities, so that casts through these types
can retain capability properties.
When a dereference is attempted on a capability without a valid tag &mdash;
including load, store, and instruction fetch &mdash; a hardware exception fires
(see [Capability-related faults](capability-faults.html)).
<!--
%\psnote{It would be better to exhaustively list them (is it just intptr\_t and uintptr\_t?) rather than this vague "such as"}
%\arnote{There are also cases such as C++11 strongly typed enums that use uintcap\_t as the underlying type, but we really don't need to mention this here. And I'm also not sure if we want to keep allowing that since enums should really be integer values only}
-->

On the whole, the effects of pointer provenance validity are non-disruptive to
C/C++ source code.
However, a number of cases exist in language runtimes and other
(typically less portable) C code that conflate integers and pointers that can
disrupt provenance validity.
In general, generated code will propagate provenance validity in only two
situations:

* **Pointer types** The compiler will generate suitable code to propagate
  the provenance validity of pointers by using capability load and store
  instructions.
  This occurs when using a pointer type (e.g., `void *`) or an
  integer type defined as being able to hold a pointer (e.g.,
  `intptr_t`).
  As with attempting to store 64-bit pointers in 32-bit integers on 64-bit
  architectures, passing a pointer through an inappropriate type will lead to
  truncation of metadata (e.g., the validity tag and bounds).
  It is therefore important that a suitable type be used to hold pointers.

  This pattern often occurs where an opaque field exists in a data structure
  &mdash; e.g., a `long_t` argument to a callback in older C code &mdash; that
  needs to be changed to use a capability-oblivious type such as `intptr_t`.

<!--
\psnote{I'm not sure this document has explained the ISA behavior concretely enough for this stuff to really make sense &mdash; the previous description was quite high-level.  Maybe somewhere it should be explicit that registers have tags, that load and store instructions must be via a capability, and that there are both capability and non-capability load and store instructions, with the former preserving tags (both ways) and the latter clearing them?}
-->

* **Capability-oblivious code** In some portions of the C/C++ runtime and
  compiler-generated code, it may not be possible to know whether memory is
  intended to contain a pointer or not &mdash; and yet preserving pointers is
  desirable.
  In those cases, memory accesses must be performed in a way that preserves
  pointer provenance.
  In the C runtime itself, this includes `memcpy`, which must use
  capability load and store instructions to transparently propagate capability
  metadata and tags.

  A useful example of potentially surprising code requiring modification for
  CHERI C/C++ is `qsort`.
  Some C programs assume that `qsort` on an array of data structures
  containing pointers will preserve the usability of those pointers.
  As a result, `qsort` must be modified to perform memory copies using
  pointer-based types, such as `intptr_t`, when size and alignment
  require it.
