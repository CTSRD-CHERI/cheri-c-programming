## Compiler optimizations and undefined behavior

Many of CHERI's protections can be seen as an effort to determine new, and
safer, dynamic outcomes to undefined behavior specified in the C/C++
languages.
For example, CHERI's dynamic bounds checking and exception throwing replaces
the common (and specification-compliant) behavior of enabling arbitrary code
execution found in many C/C++ implementations.
There is, however, an important interaction with compiler optimizations:
Compilers are allowed to (and not infrequently do) assume that software will
not behave in undefined ways, and are permitted to optimize on that basis.
In this section, we explore several such cases that are important to be aware
of in understanding key limitations to the CHERI C/C++ approach.
This is an active area of research at SRI/Cambridge.

### Uninitialized local variables

In the C language, it is undefined behavior to depend on the value of an
uninitialized local variable, and bugs triggering this behavior are sometimes
exploitable vulnerabilities.
For example, an integer or pointer value may "shadow through" from a now free
stack frames, which could lead to misbehavior such as attacker-controlled
control flows.

CHERI does not, itself, prevent the use of uninitialized values, although it
does impose a number of protections that hamper exploitation (such as tagged
pointers, sealed control-flow pointers, spatial safety, and temporal safety).
Further, compartmentalization limits the scope for stack reuse, preventing
(for example) application compartments from reusing stack space previously
used for privileged components such as the run-time linker and heap
allocators.
However, CHERI in isolation does not prevent the use of undefined values
exposed by uninitalized local variables,and it remains important to prevent or
mitigate these vulnerabilities in other ways.

**Advice to developers**: Compilers support both warnings regarding the use of
  unitialized local variables, as well as options to automatically zero (or
  otherwise initialize) uninitialized local variables.
  We strongly recommend that uninitialized local variables be considered a
  compile-time error or that automatic initialization be enabled, when using
  CHERI C/C++ for memory protection.

**Ongoing research**: The CHERI research community is actively exploring
  potential extensions to CHERI to detect or prevent undefined behavior.

### Uninitialized arguments and return values

As with software bugs involving uninitialized local variables, CHERI does not
directly prevent vulnerabilities from arising as a result of uninitialized
arguments or return values.
And, as with uninitialized local variabls, compilers are permitted to optimize
based on the assumption that no undefined behavior occurs in execution, and
may generate code that causes surprising resuls in the presence of improper
initialization.
CHERI indirectly affects the exploitability of those vulnerabilities by
virtue of pointer tagging, spatial safety, and temporal safety, but these
limited exploitation rather than preventing vulnerability.

**Advice to developers**: As with uninitialized local variables, compilers
  support warnings regarding the use of uninitialized arguments and failures
  to return values as defined by a function's prototype.
  We strongly recommend that uninitialized arguments and return values be
  considered compile-time errors.

### Out-of-bounds memory accesses

Compilers are, however, permitted to assume that undefined behavior does not
occur for the purposes of optimization, and may, for example, elide stores
that can be statically determined to be out of bounds.

For example, dynamic bounds checking on memory allocations frequently replaces
the specification-compliant corruption of other in-memory structures when a
buffer overflow occurs with a dynamic exception that, by default, terminates
an application.

Further, for a buffer with suitably scoped lifetime, not only may the store be
elided, but a later load may carry forward the expected value for being
loaded, despite the store not taking place.

This interacts importantly with the definitions of spatial and temporal safety
in CHERI, which are focused on *non-aliasing* rather than *precise
exceptions*.
If the compiler optimizes out an out-of-bounds store, then no CHERI exception
will be thrown dynamically.
Further, out-of-bounds loads may not only not throw an exception, but they may
see the value that was not stored.
CHERI's spatial safety is not violated, as no other object was corrupted.
However, this behavior may be surprising, and is a more broad example of how
memory-unsafe code may not fail stop, leading to further undefined execution
that could have surprising or insecure behavior.

**Advice to developers**: If memory-safety vulnerabilities are reported in
  software, it is important to validate the protection CHERI provides through
  testing and not just source-code inspection.
  This will help differentiate cases in which a clean "fail stop" is generated
  vs. those in which other undefined behavior may be reached, which must be
  analyzed in order to determine impact.

**Ongoing research**: The SRI/Cambridge team is actively investigating the
  impact of undefined behavior and compiler optimizations alongside CHERI
  memory protection.
