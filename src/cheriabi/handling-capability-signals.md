## Handling capability-related signals

When a capability hardware exception fires, the operating system will map it
into the UNIX `SIGPROT` signal.
By default, this signal terminates the process, but the signal can be caught
by registering a `SIGPROT` handler.
When the signal handler fires, `siginfo.si_code` will be set to
describe the cause of the fault; available values, defined in
`signal.h`, include:

* **`PROT_CHERI_BOUNDS`**: Capability bounds fault &mdash; an out-of-bounds access was
  attempted.
* **`PROT_CHERI_PERM`**: Capability permission fault &mdash; the attempted access
  exceeded the permissions granted by a capability.
* **`PROT_CHERI_SEALED`**: Capability sealed fault &mdash; dereferencing a sealed
  capability was attempted.
* **`PROT_CHERI_TAG`**: Capability tag fault &mdash; dereferencing an invalid
  capability was attempted.
