# C APIs to get and set capability properties
<!--
\label{sec:cheri-apis}
-->

<!--
\rwnote{I wonder if we should talk more about permissions?  Perhaps not in
  this document, in which case possibly we should talk about them less?}
\amnote{If this is intended as a document to guide porting efforts perhaps
  we should mention them only as background info? If this becomes a summary
  of CHERI programming patterns then we probably want a section that talks
  about permissions as well.}
-->

CHERI C/C++ supports a number of new APIs to get and set capability
properties given a pointer argument.
Although most software does not need to directly manage capability properties,
there are some cases when application code needs to further constrain
permissions or limit bounds associated with pointers.
For example, high-performance applications may contain custom memory
allocators and wish to narrow bounds and permissions on returned pointers
to prevent overflows between its own allocations.
