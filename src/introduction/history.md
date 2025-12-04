## Version history

The current web version is a living document being prepared for release as a
second edition in late 2025, based on five years of deployed experience with
hundreds of CHERI C/C++ developers working on various CHERI platforms
including Arm's Morello prototype, Microsoft's CHERIoT, Codasip's X730,
the University of Cambridge's CHERI-Toooba, and Capabilities Limited's
CVA6-CHERI platforms.

### 2020

We published the first version of the *CHERI C/C++ Programming Guide* in June
2020.

### 2025

This work-in-progress version of the *CHERI C/C++ Programming Guide* contains
the following changes:

 * Conversion to mdbook from LaTeX to enable a live web version.
 * Update cited articles and technical reports.
 * Better define, and discourage use of, CHERI Hybrid C/C++.
 * Include information on using CHERI C/C++ on a more diverse range of
   platforms, including Morello and CHERIoT, as well as work on arising
   CHERI-adapted OSes such as CHERI Linux and seL4.
 * Include information on printing capability values via `strfcap(3)` and
   `printf(3)`.
 * Discuss the goal of non-aliasing spatial and temporal memory safety, and
   explore when exceptions may be, or must be, delivered.
 * Document a subset of `malloc_revoke(3)` APIs controlling revocation for the
   system heap allocator.
 * Note that some behaviors, such as bounds precision and revocation behavior,
   are implementation defined.
 * Document expectations for in-memory capabilities, in particular the
   portability of `NULL` pointer values, and non-portability of any other
   assumptions.
 * Document that subobject bounds, as currently implemented, are
   opportunistic, and may not be precise.
 * Provide more detailed discussion of the limitations of the CHERI C/C++
   approach including with respect to integer-pointer type safety vs full
   pointer type safety, compile-time uncertainty on types, bounds imprecision,
   unions, stack temporal safety, and compiler optimizations.
 * Numerous minor editorial and formatting improvements.
