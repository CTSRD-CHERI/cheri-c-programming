# The CHERI C/C++ run-time environment

CHERI C code executes within a capability-aware run-time environment
&mdash; whether "bare metal" with a suitable runtime, or in a richer, OS-based
process environment such as CheriABI (see [CheriABI](../cheriabi)),
which ensures that:

 * capabilities are context switched (if required);
 * tags are maintained by the OS virtual-memory subsystem (if present);
 * capabilities are supported in OS control operations such as
    debugging (as needed);
 * system-call arguments, the
run-time linker, and other aspects of the OS Application Binary Interface
(ABI) utilize capabilities rather than integer pointers; and
  * the C/C++-language runtime implements suitable capability preservation
    (e.g., in `memcpy`) and restriction (e.g., in `malloc`).

In CheriBSD, our CHERI-extended version of the open-source FreeBSD operating
system, CheriABI operates as a complete additional OS ABI.
CheriABI is implemented in the style of a 32-bit or 64-bit OS personality, in
that it requires its own set of suitably compiled system libraries and classes.
We have also successfully adapted bare-metal runtimes, such as newlib, and
embedded operating systems, such as FreeRTOS (CheriFreeRTOS) and RTEMS
(CHERI-RTEMS), to support CHERI memory protection.

Outside of the OS and language runtime themselves, CHERI C/C++ require
relatively few source-code-level changes to C/C++-language software.
We explore those changes in the remainder of this document.
