## Definitions

CHERI Clang/LLVM and LLD implement the following new language,
code-generation, and linkage models:

* **CHERI C/C++** are C/C++-language dialects tuned to requirements arising from
implementing all pointers using CHERI capabilities.
This includes all explicit pointers (i.e., those declared by the programmer)
and all implied pointers (e.g., those used to access local and global
variables).
For example, they diverge from C/C++ implementations on conventional
architectures by preventing pointers passed through integer type other
than `uintptr_t` and `intptr_t` from being dereferenced.
New Application Programming Interfaces (APIs) provide access to capability
features of pointers, including getting and setting their bounds, required
by selected software such as memory allocators.
The vast majority of C/C++ source code we have encountered requires little
or no modification to be compiled as CHERI C/C++.

* **Pure-capability machine code** is compiled code (or hand-written assembly)
that utilizes CHERI capabilities for all memory accesses &mdash; including
loads, stores, and instruction fetches &mdash; rather than integer addresses.
Capabilities are used to implement pointers explicitly described in the source
program, and also to implement implied pointers in the C execution
environment, such as those used for control flow.
Pure-capability machine code is not binary compatible with capability-unaware
code using integer pointers, not least due to the different size of the
pointer data type.

* **CHERI hybrid C/C++** are further language dialects in which only selected
pointers are implemented using capabilities, with the remainder implemented
using integers as on conventional architectures.
We have primarily used hybrid C in systems software that bridges between
environments executing pure-capability machine code and those running largely
or entirely non-CHERI-aware machine code.
While hybrid machine code has stronger binary compatibility with conventionally
generated code, it provides little or no memory protection, and its use is not
generally recommended.

The remainder of this document describes the CHERI C/C++ programming languages,
as mapped into pure-capability machine code; hybrid C/C++ will not be
considered further.
