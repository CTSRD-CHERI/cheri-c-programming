## CHERI-related header files

A set of compiler built-in functions provide access to capability properties
of pointers.
Two new header files (distributed as part of the CHERI Clang compiler)
provide access to further CHERI-related programming
interfaces including more human-friendly macro wrappers around the compiler
builtins, and also definitions of key CHERI constants:

* **`cheriintrin.h`**: defines interfaces to access and
  modify capability properties.
  It also defines constants for capability permissions that are portable
  across all implementations of CHERI.

* **`cheri.h`**: provides macros for slightly higher-level operations
  such as the manipulation of low pointer bits (see
  [Bitwise operations on capability types](../impact/bitwise-operations.html)).

When compiling for CheriBSD, the following header provides additional
constants relating to OS use of capabilities &mdash; for example, software-defined
permission bits:

* **`cheri/cheri.h`**: defines constants such as those used in the
  capability permission mask.

<!--
%`cheri/cheric.h`: defines interfaces to access and
%  modify capability properties.

\rwnote{This section may need updating once we've converged OS and compiler
  versions of cheri.h, and done any necessary header refactoring.}
-->
