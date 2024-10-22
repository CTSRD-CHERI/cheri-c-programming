# Definitions

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

While the focus of this document is CHERI C/C++, CHERI is an architectural
feature able to support other software use cases including other
C/C++-language mappings into its features.
Another mapping is hybrid C/C++, in which only selected pointers are
implemented using capabilities, with the remainder implemented using integers.
We have primarily used hybrid C in systems software that bridges between
environments executing pure-capability machine code and those running largely
or entirely non-CHERI-aware machine code.
For example, a largely CHERI-unaware CheriBSD kernel can host pure-capability
processes using its CheriABI wrapper implemented in hybrid C (see
[CheriABI](../cheriabi)).
Hybrid machine code has stronger binary compatibility, but weaker protection,
than pure-capability machine code.
We do not consider hybrid C further in this document.
