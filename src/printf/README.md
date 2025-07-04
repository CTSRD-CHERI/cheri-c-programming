## Printing capabilities from C

Capability pointers carry additional metadata that it can sometimes be useful
to print to a human readable string.
CHERI C/C++ defines a decoded string format for capabilities, which may be
accessed indirectly via existing C APIs such as `printf(3)`, `snprintf(3)`, or
directly via calls to the `strfcap(3)` function itself.
