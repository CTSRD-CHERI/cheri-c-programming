# CHERI C/C++

The architectural-capability type can be used in a variety of ways by
software.
One particularly useful use case is in implementing *CHERI C/C++*.
In this model, all C/C++ language-visible pointer types, as well as any
implied pointers implementing vtables, return addresses, global variables,
arrays of variadic-function arguments, and so on, are implemented using
capabilities with tight bounds.
This allows the architecture to imbue pointers with protection by virtue of
architectural provenance validity, bounds checking, and permission checking,
protecting pointers from corruption and providing strong spatial memory
safety.
