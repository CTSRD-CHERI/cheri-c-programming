## Architectural rules for capability use

The architecture enforces several important security properties on changes to
this metadata:

* **Provenance validity** ensures that capabilities can be used &mdash; for
  load, store, instruction fetch, etc. &mdash; only if they are derived via valid
  transformations of valid capabilities.
  This property holds for capabilities in both registers and memory.

* **Monotonicity** requires that any capability derived from another
  cannot exceed the permissions and bounds of the capability from which it was
  derived (leaving aside sealed capabilities, used for domain transition,
  whose mechanism is not detailed in this report).

At boot time, the architecture provides initial capabilities to the firmware,
allowing data access and instruction fetch across the full address space.
Additionally, all tags are cleared in memory.
Further capabilities can then be derived (in accordance with the monotonicity
property) as they are passed from firmware to boot loader, from boot loader to
hypervisor, from hypervisor to the OS, and from the OS to the application.
At each stage in the derivation chain, bounds and permissions may be
restricted to further limit access.
For example, the OS may assign capabilities for only a limited portion of the
address space to the user software, preventing use of other portions of the
address space.

Similarly, capabilities carry with them *intentionality*: when a
process passes a capability as an argument to a system call, the OS kernel can
carefully use only that capability to ensure that it does not access other
process memory that was not intended by the user process &mdash; even though the
kernel may in fact have permission to access the entire address space through
other capabilities it holds.
This is important, as it prevents "confused deputy" problems, in which a more
privileged party uses an excess of privilege when acting on behalf of a less
privileged party, performing operations that were not intended to be
authorized.
For example, this prevents the kernel from overflowing the bounds on a
userspace buffer when a pointer to the buffer is passed as a
system-call argument.

The hardware furthermore guarantees that capability tags and capability data is written atomically.
For example, if one thread stores a valid capability and another writes arbitrary data to the same location, it is impossible to observe the arbitrary data with the validity bit set.

These architectural properties provide the foundation on which a
capability-based OS, compiler, and runtime can implement C/C++-language memory
safety.
They have been made precise and have been proved, with machine-checked proof,
to hold for the CHERI-MIPS architecture.[^1]

[^1]: Kyndylan Nienhuis, Alexandre Joannou, Thomas Bauereiss, Anthony Fox, Michael Roe, Brian Campbell, Matthew Naylor, Robert M. Norton, Simon W. Moore, Peter G. Neumann, Ian Stark, Robert N. M. Watson, and Peter Sewell. [Rigorous engineering for hardware security: Formal modelling and proof in the CHERI design and implementation process](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/202005oakland-cheri-formal.pdf). In Proceedings of the 41st IEEE Symposium on Security and Privacy (Oakland 2020). San Jose, CA, USA, May 18-20, 2020.
