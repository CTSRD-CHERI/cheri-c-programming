## Stack temporal safety

CHERI includes different temporal-safety mechanisms at different
microarchitectural scales.
In general, those mechanisms scale well to providing temporal safety for
services such as memory mappings and heap allocations, but do not perform
sufficiently well to enable generalized stack temporal safety able to address
use-after-function-return and use-out-of-scope vulnerabilities.
In the presence of compartmentalization support (e.g., for libraries in
CheriBSD or between compartments in CHERIoT RTOS), there may be stronger
protections preventing stack reuse or limiting the flow and reuse of stack
memory, but these are not provided within compartments.

**Advice to developers**: Existing sanitizers used to detect some
  use-after-function-return and use-out-of-scope bugs should be used when
  writing code intended to be robust on CHERI.
  As exploitation of stack temporal-safety vulnerabilities often involves the
  use of uninitialized stack values, compiler features automatically
  initialize stack variables can also play an important role in mitigation
  (see below).
  Finally, integer-pointer and other CHERI protections, such as sealing of
  code pointers, provide significant robustness against exploitation of such
  vulnerabilities -- but cannot be argued to strongly mitigate stack
  temporal-safety vulnerabilities in the same way that can be argued for heap
  allocations.

**Ongoing research**: The broader CHERI research community has been exploring
  a variety of mechanisms to provide probablistic or deterministic stack
  protections at varying costs, including concepts such as capability flow
  control and capability linearity.
  None have yet been deemed appropriate for widespread adoption, but we hope
  that at least one mechanism will proceed to maturity in due course.
