<!-- ANCHOR: cover -->

# CHERI C/C++ Programming Guide

* Robert N. M. Watson (University of Cambridge, Capabilities Limited),
* Alexander Richardson (University of Cambridge),
* Brooks Davis (SRI International),
* John Baldwin (Ararat River Consulting, LLC),
* David Chisnall (Microsoft Research),
* Jessica Clarke (University of Cambridge),
* Nathaniel Filardo (Microsoft Research),
* Simon W. Moore (University of Cambridge),
* Edward Napierala (University of Cambridge, Capabilities Limited),
* Allison Randal (Capabilities Limited),
* Peter Sewell (University of Cambridge), and
* Peter G. Neumann (SRI International)

This is the CHERI Pure-Capability C/C++ Programming Guide, a short guide to
help developers working with pure-capability C/C++ understand the benefits
that it brings, any code adaptations they might need to make, and how to
interpret new compiler warnings and errors that arise with pure-capability
code.

*This is a living document; feedback and contributions are welcomed.
Please see our
[GitHub Repository](https://github.com/CTSRD-CHERI/cheri-c-programming) for
source code and an issue tracker.
There is a [rendered version on the web](https://ctsrd-cheri.github.io/cheri-c-programming/), which is automatically updated when the git repository is
committed to.*

The [2020 published version of the CHERI C/C++ Programmers
Guide](https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-947.html) can be cited
as follows:

Robert N. M. Watson, Alexander Richardson, Brooks Davis, John Baldwin, David Chisnall, Jessica Clarke, Nathaniel Filardo, Simon W. Moore, Edward Napierala, Peter Sewell, and Peter G. Neumann. CHERI C/C++ Programming Guide, Technical Report UCAM-CL-TR-947, Computer Laboratory, June 2020.

Or in BibTex:

```
@TechReport{UCAM-CL-TR-947,
  author =	 {Watson, Robert N. M. and Richardson, Alexander and Davis,
          	  Brooks and Baldwin, John and Chisnall, David and Clarke,
          	  Jessica and Filardo, Nathaniel and Moore, Simon W. and
          	  Napierala, Edward and Sewell, Peter and Neumann, Peter G.},
  title = 	 {{CHERI C/C++ Programming Guide}},
  year = 	 2020,
  month = 	 jun,
  url = 	 {https://www.cl.cam.ac.uk/techreports/UCAM-CL-TR-947.pdf},
  institution =  {University of Cambridge, Computer Laboratory},
  doi = 	 {10.48456/tr-947},
  number = 	 {UCAM-CL-TR-947}
}
```

## Acknowledgments

We gratefully acknowledge the helpful feedback from our colleagues, including
Hesham Almatary, Ruben Ayrapetyan, Silviu Baranga, Jacob Bramley, Rod Chapman,
Paul Gotch, Al Grant, Brett Gutstein, Alfredo Mazzinghi, Alan Mycroft, and Lee
Smith.

This work was supported by the Defense Advanced Research Projects Agency
(DARPA) and the Air Force Research Laboratory (AFRL), under contracts
FA8750-10-C-0237 ("CTSRD") and HR0011-18-C-0016 ("ECATS").
The views, opinions, and/or findings contained in this report are those of the
authors and should not be interpreted as representing the official views or
policies of the Department of Defense or the U.S. Government.

This work was supported in part by the Innovate UK project Digital Security by
Design (DSbD) Technology Platform Prototype, 105694.

This work was supported by part by the Engineering and Physical Sciences
Research Council (EPSRC) under UKRI3001: CHERI Research Centre, and under the
EPSRC REMS Programme Grant (EP/EP/K008528/1).

This project has received funding from the European Research Council (ERC)
under the European Union’s Horizon 2020 research and innovation programme
(grant agreement No 789108), ERC Advanced Grant ELVER.

We also acknowledge Arm Limited, HP Enterprise, and Google, Inc.
Approved for Public Release, Distribution Unlimited.

## Building

Building the book from the Markdown sources requires
[mdBook](https://github.com/rust-lang/mdBook). Once installed, `mdbook build`
will build the static HTML files in the `book/` directory, whilst `mdbook
serve` will build and serve them at `http://localhost:3000`. Please refer to
the mdBook documentation for futher options.
