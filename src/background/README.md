# Background

CHERI extends conventional processor Instruction-Set Architectures (ISAs) with
support for *architectural capabilities*.
One important use for this new hardware data type is in the implementation
of safer C/C++ pointers and the code or data they point at.

Our 2019 technical report, [*An Introduction to
CHERI*](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-941.pdf), provides a
more detailed overview of the CHERI architecture, ISA modeling, hardware
implementations, and software stack[^1].
Our more recent 2025 article in IEEE Security and Privacy,
[*CHERI: Hardware-Enabled C/C++ Memory Protection at
Scale*](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10568212),
reviews recent research and results[^2].

[^1]: Robert N. M. Watson, Simon W. Moore, Peter Sewell, and Peter G. Neumann.
[An Introduction to
CHERI](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-941.pdf), Technical
Report UCAM-CL-TR-941, Computer Laboratory, September 2019.

[^2]: Robert N.M. Watson, David Chisnall, Jessica Clarke, Brooks Davis,
Nathaniel Wesley Filardo, Ben Laurie, Simon W. Moore, Peter G. Neumann,
Alexander Richardson, Peter Sewell, Konrad Witaszczyk, and Jonathan Woodruff.
[CHERI: Hardware-Enabled C/C++ Memory Protection at
Scale](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10568212),
IEEE Security & Privacy, vol. 22, no. 04, pp. 50-61, July-August 2024.
