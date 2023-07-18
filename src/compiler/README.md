# CHERI compiler warnings and errors

The CHERI Clang compiler includes many diagnostic warnings to identify code
that is incompatible with CHERI C/C++ or may result in behavioral
differences.
In many cases, a successful compilation that does not emit any CHERI-specific
warnings will result in a functional spatially-safe program.
However, some incompatibilities (e.g., memory allocators returning
insufficiently aligned pointers) cannot yet be diagnosed statically.
This section describes some of the more-commonly seen compiler warnings and
provides suggestions on how to change the source code to be compatible with
CHERI C/C++.
All these warnings are enabled when the `-Wall` compiler flag is
set.
