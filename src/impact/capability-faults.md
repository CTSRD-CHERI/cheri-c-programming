# Capability-related faults
<!--
\label{sec:faults}
-->

When architectural capability properties are violated, such as by an attempt
to dereference an invalid capability, access memory outside the bounds of a
capability, or perform accesses not authorized by the permissions on a
capability, this typically leads to a hardware exception (trap).
Operating-system kernels are able to catch this exception via a trap handler,
optionally delivering it to the run-time environment via OS-specific
mechanisms.

However, the language-level behavior of CHERI C/C++ is considerably more
subtle: existing undefined behavior semantics in C are retained.
The compiler is free to assume that loads and stores will not trap (i.e., that
any program is free of undefined behavior), and may optimize under this
assumption, including reordering code.
Architectural traps occur when dynamic loads and stores are attempted, and
reordering could lead to potential confusing behavior for programmers.

In the CheriABI process environment, the operating system catches the hardware
exception and delivers a `SIGPROT` signal to the user process;
further information may be found in [CheriABI](../cheriabi).
In other environments, such as bare metal or under an embedded OS, behavior is
specific to those environments, as it will depend both on how architectural
exceptions are handled, and how those events are delivered to the C-language
stack.
Fail stop may be appropriate behavior in some environments, and is in fact the
default behavior in CheriABI when `SIGPROT` is not handled.

<!--
\rwnote{We've opted to use the term "hardware exception" throughout, and
  mention "traps" only here.  This could cause confusion with respect to C++
  exceptions .. but perhaps less so than if we used the word "exception"
  unadorned.}
-->
