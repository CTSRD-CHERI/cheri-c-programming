## Pointer comparison

In CHERI C/C++, pointer comparison considers only the
integer address part of a capability.
This means that differences in tag validity, bounds, permissions, and so on,
will not be considered when by C operators such as `==`, `<`, and `<=`.
On the whole, this leads to intuitive behavior in systems software, where,
for example, `malloc` adjusts bounds on a pointer before returning it to
a caller, and then expects an address-wise comparison to succeed when the
pointer is later returned via a call to `free`.  <!--
\nwfnote{I don't think I particularly like that example, since the thing `free`
is nominally comparing against is the bounded return from `malloc`.}
-->
However, this behavior could also lead to potentially confusing results; for
example:

* If a tag on a pointer is lost due to non-provenance-preserving
  `memcpy` (e.g., a `for` loop copying a sequence of bytes), the
  source and destination pointers will compare as equal even though the
  destination will not be dereferenceable.

* If a `realloc` implementation returns a pointer to the same
  address, but with different bounds, a caller check to see if the passed and
  returned pointers are equal will return `true` even though an access
  might be permitted via one pointer but not the other.

<!--
\psnote{I'm curious about the impact on compiler optimisation, where in the scope of \texttt{if (p==q)} compilers will often assume the two are interchangeable.  Comment on that?
 }
 \arnote{The choice between exact vs non-exact equals is made extremely late in code generation, it just chooses between emitting CEq and CExEq.
 Compiler analyses use a stricter definition of equality.
 In clang that should include some cases of taking provenance into account for alias information.}
-->

However, practical experience has suggested that the current semantics produce fewer
subtle bugs, and require fewer changes, than having comparison operators take
the tag or other metadata into account.[^6]

[^6]: The CHERI Clang compiler supports an experimental flag `-cheri-comparison=exact` that causes capability equality comparisons to also include capability metadata and the tag bit.

<!--
\arnote{default behavior=\texttt{-cheri-comparison=address}}
}
-->
