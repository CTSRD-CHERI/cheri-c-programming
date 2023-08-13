# Further reading

## The CHERI ISA

The primary reference for the CHERI Instruction-Set Architecture (ISA) is the
ISA specification; at the time of writing, the most recent version is
[Capability Hardware Enhanced RISC Instructions: CHERI Instruction-Set
Architecture (Version
7)](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-927.pdf)[^1].

## An Introduction to CHERI

Our technical report, [An Introduction to
CHERI](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-941.pdf), provides a
high-level overview of the CHERI architecture, ISA modeling, hardware
implementations, and software stack[^2].

## C/C++ Memory Safety

Published at ASPLOS 2015, [Beyond the PDP-11: Architectural support for a
memory-safe C abstract
machine](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/201503-asplos2015-cheri-cmachine.pdf)
describes idiomatic C and spatial memory protection[^3].

We published a paper on our memory-safe OS userspace and application suite,
[CheriABI: Enforcing Valid Pointer Provenance and Minimizing Pointer Privilege
in the POSIX C Run-time
Environment](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/201904-asplos-cheriabi.pdf),
at ASPLOS 2019[^4].
We also released an [extended technical-report version of this
paper](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-932.pdf) that includes
greater implementation detail[^5].

We published [Cornucopia: Temporal Safety for CHERI
Heaps](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/2020oakland-cornucopia.pdf) at Oakland 2020, explaining how to implement "sweeping revocation"
using virtual-memory acceleration[^6].

We published our paper, [Exploring C Semantics and Pointer
Provenance](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/201901-popl-cerberus.pdf),
and the implications for software design, at POPL 2019; CHERI C was a case
study in the practical enforcement of capability provenance-validity
enforcement[^7].

[^1]: Robert N. M. Watson, Peter G. Neumann, Jonathan Woodruff, Michael Roe,
Hesham Almatary, Jonathan Anderson, John Baldwin, David Chisnall,
Brooks Davis, Nathaniel Wesley Filardo, Alexandre Joannou, Ben Laurie,
A. Theodore Markettos, Simon W. Moore, Steven J. Murdoch, Kyndylan Nienhuis,
Robert Norton, Alex Richardson, Peter Rugg, Peter Sewell, Stacey Son,
Hongyan Xia. [Capability Hardware Enhanced RISC Instructions: CHERI
Instruction-Set Architecture (Version
7)](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-927.pdf), Technical Report
UCAM-CL-TR-927, Computer Laboratory, June 2019.

[^2]: Robert N. M. Watson, Simon W. Moore, Peter Sewell, and Peter G. Neumann.
[An Introduction to
CHERI](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-941.pdf), Technical
Report UCAM-CL-TR-941, Computer Laboratory, September 2019.

[^3]: David Chisnall, Colin Rothwell, Robert N.M. Watson, Jonathan Woodruff,
Munraj Vadera, Simon W. Moore, Michael Roe, Brooks Davis, and
Peter G. Neumann. [Beyond the PDP-11: Architectural support for a memory-safe
C abstract machine](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/201503-asplos2015-cheri-cmachine.pdf),
Proceedings of the Twentieth International Conference on Architectural Support
for Programming Languages and Operating Systems (ASPLOS 2015), Istanbul,
Turkey, March 2015.

[^4]: Brooks Davis, Robert N. M. Watson, Alexander Richardson,
Peter G. Neumann, Simon W. Moore, John Baldwin, David Chisnall,
Jessica Clarke, Nathaniel Wesley Filardo, Khilan Gudka, Alexandre Joannou,
Ben Laurie, A. Theodore Markettos, J. Edward Maste, Alfredo Mazzinghi,
Edward Tomasz Napierala, Robert M. Norton, Michael Roe, Peter Sewell,
Stacey Son, and Jonathan Woodruff. [CheriABI: Enforcing Valid Pointer
Provenance and Minimizing Pointer Privilege in the POSIX C Run-time
Environment](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/201904-asplos-cheriabi.pdf).
In Proceedings of 2019 Architectural Support for Programming Languages and
Operating Systems (ASPLOS’19). Providence, RI, USA, April 13-17, 2019.

[^5]: Brooks Davis, Robert N. M. Watson, Alexander Richardson,
Peter G. Neumann, Simon W. Moore, John Baldwin, David Chisnall,
Jessica Clarke, Nathaniel Wesley Filardo, Khilan Gudka, Alexandre Joannou,
Ben Laurie, A. Theodore Markettos, J. Edward Maste, Alfredo Mazzinghi,
Edward Tomasz Napierala, Robert M. Norton, Michael Roe, Peter Sewell,
Stacey Son, and Jonathan Woodruff. [CheriABI: Enforcing valid pointer
provenance and minimizing pointer privilege in the POSIX C run-time
environment](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-932.pdf),
Technical Report UCAM-CL-TR-932, Computer Laboratory, January 2019.

[^6]: Nathaniel Wesley Filardo, Brett F. Gutstein, Jonathan Woodruff,
Sam Ainsworth, Lucian Paul-Trifu, Brooks Davis, Hongyan Xia,
Edward Tomasz Napierala, Alexander Richardson, John Baldwin, David Chisnall,
Jessica Clarke, Khilan Gudka, Alexandre Joannou, A. Theodore Markettos,
Alfredo Mazzinghi, Robert M. Norton, Michael Roe, Peter Sewell, Stacey Son,
Timothy M. Jones, Simon W. Moore, Peter G. Neumann, and Robert N. M. Watson.
[Cornucopia: Temporal Safety for CHERI
Heaps](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/2020oakland-cornucopia.pdf).
In Proceedings of the 41st IEEE Symposium on Security and Privacy (Oakland
2020). San Jose, CA, USA, May 18-20, 2020.

[^7]: Kayvan Memarian, Victor B. F. Gomes, Brooks Davis, Stephen Kell,
Alexander Richardson, Robert N. M. Watson, and Peter Sewell. [Exploring C
Semantics and Pointer
Provenance](https://www.cl.cam.ac.uk/research/security/ctsrd/pdfs/201901-popl-cerberus.pdf).
In Proceedings of the 46th ACM SIGPLAN Symposium on Principles of Programming
Languages (POPL), Cascais, Portugal, 13-19 January, 2019.
