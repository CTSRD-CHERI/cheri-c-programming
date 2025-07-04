## The CHERI C/C++ run-time environment

CHERI C code executes within a capability-aware run-time environment
&mdash; whether "bare metal" with a suitable runtime, or in a richer, OS-based
process environment such as CheriABI (see [CheriABI](../cheriabi)) or
CHERIoT RTOS, which ensures that:

 * capabilities are context switched (if required);
 * tags are maintained by the OS virtual-memory subsystem (if present);
 * capabilities are supported in OS control operations such as
    debugging (as needed);
 * system-call arguments, the
run-time linker, and other aspects of the OS Application Binary Interface
(ABI) utilize capabilities rather than integer pointers;
 * the C/C++-language runtime implements suitable capability preservation
    (e.g., in `memcpy`) and restriction (e.g., in `malloc`); and
 * temporal safety is enforced by heap allocators (if supported).

CHERI is supported by a growing set of operating systems:

 * CheriBSD, the CHERI-extended version of the open-source FreeBSD operating
   system, CheriABI operates as a complete additional OS ABI.
   CheriABI is implemented in the style of a 32-bit or 64-bit OS personality,
   in that it requires its own set of suitably compiled system libraries and
   classes.
   Userlevel runs with referential, spatial, and temporal safety.
   At the time of writing, the kernel supports referential and spatial
   safety, but not temporal safety.
 * CHERI Linux also implements a pure-capability kernel and process
   environment modeled on CheriABI that support referential and spatial
   safety.
 * A number of bare-metal runtimes, such as newlib, and embedded operating
   systems, such as FreeRTOS (CheriFreeRTOS) and RTEMS (CHERI-RTEMS), have
   been adapted to support referential and spatial memory protection using
   CHERI.
 * seL4 has been updated (out of tree) to support referential and spatial
   memory protction using CHERI.
 * CHERIoT RTOS implements referential, spaital, and temporal memory
   protection using CHERI.

Outside of the OS and language runtime themselves, CHERI C/C++ require
relatively few source-code-level changes to C/C++-language software.
Exceptions to this rule of thumb typically take the form of compiler
toolchain, low-level C/C++ runtimes such as run-time linkers, and high-level
language runtimes that may (for example) include just-in-time compilers.

We explore the changes required to software in the remainder of this document.
