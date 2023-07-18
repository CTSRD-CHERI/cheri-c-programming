# Impact on the C/C++ programming model

Several kinds of changes may be required by programmers; the extent to which
these changes impact a particular library or application will depend
significantly on its idiomatic use of C.
Our experience suggests that low-level system components such as run-time
linkers, debuggers, memory allocators, and language runtimes require a modest
but non-trivial porting effort.
Similarly, support classes that include, for example, custom synchronization
features, may also require moderate adaptation.
Other applications may compile with few or no changes &mdash; especially if they
are already portable across 32-bit and 64-bit platforms and are written in a contemporary C or C++ dialect.
In the following sections, we consider various kinds of programmer-visible
changes required in the CHERI C/C++ programming environment.
In many cases, compiler warnings and errors can be used to identify potential
issues compiling code as CHERI C/C++ (see [CHERI compiler warnings and errors](../compiler)).

<!--
\rwnote{Alex: Can we use the word "most" instead of "many"?}
-->
