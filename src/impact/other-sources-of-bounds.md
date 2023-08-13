# Other sources of bounds

Bounds may also be set by other parts of the implementation.
For example, the kernel may set bounds on pointers to new memory mappings (see
[The CheriABI POSIX process environment](../cheriabi)),
and the system library may set bounds on pointers
into returned buffers from APIs &mdash; e.g., `fgetln`.
More detailed information on how C/C++ code can set bounds can be found in
[C APIs to get and set capability properties](../apis).
