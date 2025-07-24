## Capability representation in memory

Underlying implementations of CHERI are diverse, spanning 32-bit
microcontrollers (such as Microsoft's CHERIoT) to 64-bit server-class
processors (such as Arm's Morello).
CHERI C/C++ provide broad flexibility for implementations to represent
capability metadata in the ways most suitable to their individual
requirements.
One specific area in which CHERI implementations may differ is in the specific
in-memory representations of capabilities, due to not just different address
sizes, but also different tradeoffs around bounds compression, permissions,
and so on.

CHERI C/C++ in general expect that capabilities will be accessed via pointer
types, with operations such as dereferencing a pointer or performing pointer
arithmetic implemented by compiler-generated code.
Broadly, a capability consists of three parts: An address, inline metadata,
and a validity tag.
When stored in memory, CHERI capabilities are twice the size of the native
address type (e.g., 128 bits on 64-bit systems, and 64 bits on 32-bit
systems), in addition to an unaddressable tag bit.
There is one tag per capability aligned region of memory, and hence
capabilities must themselves be stored at capability alignment.

### Non-portability of the in-memory representation

To the greatest extent possible, it is desirable to write *portable CHERI
C/C++ code* that never directly interprets the in-memory representation of a
capability, with the exception of `NULL` values (see below).
Portable access to capability fields must be made using the [CHERI C APIs to
get and set capability
properties](../apis/retrieving-capability-properties.md).

However, there are cases in which writing *non-portable CHERI C/C++ code* is
both acceptable and essential, such as in the implementation of compilation,
linking, debugging, and tracing tools intentionally targeting specific target
architectures.
This is especially true when code will not be operating on the target
architecture itself, such as for cross-compilation, cross-linkage, and
cross-debugging, including in accessing core dumps.
In these cases, architecture specifications must be referenced in writing
encoding and decoding code, as there are significant variations between
platforms, and platforms themselves may also have parametizable elements to
their encoding.

### In-memory representation of NULL pointers

Conventional, integer-based architectures implement `NULL` pointers
integers with a value of `0`.
CHERI C/C++ similarly represents `NULL` as an all-zero capability value with
zero tag value, which is the only *portable* aspect of the in-memory
representation of a CHERI capability.

This has a number of implications, including that zero-filled memory with
zeroed tag values will be interpreted as being `NULL`-filled, as is the case
with conventional runtimes for C/C++.
This is particularly relevant for automatically initialized variable values
(such as global variables without specific initialization values), pre-zeroed
memory allocated by `calloc()`, or memory explicitly zeroed using
`memset(p, 0, n)`.
Similarly, storing `NULL` pointer values in memory will result in that memory
being zeroed.

The following code will always succeed:
```
	void *p = NULL;
	char zeroes[sizeof(p)];

	/* NULL == 0. */
	assert(p == 0);
	assert(cheri_address_get(p) == 0);

	/* All bytes in the NULL pointer are 0. */
	memset(zeroes, 0, sizeof(zeroes));
	assert(memcmp(&p, zeroes, sizeof(p)) == 0);
```
