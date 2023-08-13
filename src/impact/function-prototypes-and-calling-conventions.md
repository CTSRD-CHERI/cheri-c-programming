# Function prototypes and calling conventions

CHERI C/C++ distinguishes between integer and pointer types at an
architectural level, which can lead to compatibility problems with older C
programming styles that fail to unambiguously differentiate these types:

* **Unprototyped (*K&R*) functions**: Because pointers can no longer
  be loaded and stored without using capability-aware instructions, the
  compiler must know whenever a load or store might operate on a pointer
  value.
  The C-language default of using an integer type for function arguments when
  there is not an appropriate function prototype will cause pointer values to
  be handled improperly; this is also true on LP64 ABIs (e.g., most 64-bit
  POSIX systems).[^10]

  To avoid these problems, the CHERI Clang compiler emits a warning (`-Wcheri-prototypes`) by default when a function without a declared prototype is called.
  This warning is less strict than `-Wstrict-prototypes` and can be
  used to convert *K&R* functions that may cause problems.[^11]
  This should not be an issue for C code written in the last 20 years, but
  many core operating-system components can be significantly older.

* **Variadic arguments**: The calling convention for variadic functions
  passes all variadic arguments via the stack and accesses them via an
  appropriately bounded capability.
  This provides memory-protection benefits, but means that vararg functions
  must be declared and called via a correct prototype.

  Some C code assumes that the calling convention of variadic and non-variadic
  functions is sufficiently similar that they may be used interchangeably.
  Historically, this included the FreeBSD kernel's implementation of
  `open`, `fcntl`, and `syscall`.

<!--
  \rwnote{I wonder if we need to be more specific with an example here.}\arnote{TODO: Add example such as missing open() mode arguments?}
-->

[^10]: The forthcoming ISO C2x standard makes function declarations with an
empty parameter list equivalent to a parameter list consisting of a single
`void`.

[^11]: If the *K&R* function is defined within the same file, the compiler can
determine the correct calling convention and will not emit a warning.
