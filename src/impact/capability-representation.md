## Capability representation in memory

Underlying implementations of CHERI are diverse, spanning 32-bit
microcontrollers (such as CHERIoT) to 64-bit server-class processors (such as
Arm's Morello).
CHERI C/C++ provide broad flexibility for implementations to represent
capability metadata in ways most suitable to their individual requirements.
One specific area in which CHERI implementations may differ is in the specific
in-memory representations of capabilities, due to not just different address
sizes, but also different tradeoffs around bounds compression, permissions,
and so on.

CHERI C/C++ in general expect that capabilities will be accessed via pointer
types, with operations such as dereferencing a pointer or performing pointer
arithmetic implemented by compiler-generated code.
Broadly, a capability consists of three parts: An address, inline metadata,
and a validity tag.
When stored in memory, CHERI capabilities consist of two adjacent
address-sized words, stored at capability alignment:

 - The lower address-sized word holds the address.
 - The higher address-sized word holds the inline metadata.

The capability validity tag is not directly addressable in memory.

### In-memory representation of the capability address

The address word is stored in the native integer representation of the
architecture, and will be identical to the value returned by
[`cheri_address_get()`](../apis/retrieving-capability-properties.md) for the
capability.
Taking a pointer to an in-memory capability and casting it to an address-sized
integer type (e.g., `ptraddr_t`) will give access to the capability's address
or integer value.
These integer values can be printed, subjected to integer arithmetic, and so
on, but do not preserve pointer provenance and cannot be cast back to valid
pointers to be dereferenced.
Capabilities must be loaded and stored as either pointer types, or as
`intptr_t` or `uintptr_t`, as described in [Recommended use of C-language
types](recommended-use-c-types.md).

The following code will always succeed:
```
	char c, *cp = &c;

	assert(*(ptraddr_t *)&cp == cheri_address_get(cp);
```

### In-memory representation of capability inline metadata

The address and the metadata are held in addressable memory, but direct
interpretation of the metadata will be non-portable across CHERI
implementations.
There are cases in which non-portability is both acceptable and essential,
such as in the implementation of debugging and tracing tools intentionally
targeting specific target architectures, especially for cross-debugging or
coredump analysis.
However, for general-purpose software, portable access is offered via
[CHERI C APIs to get and set capability
properties](../apis/retrieving-capability-properties.md), and these should
always be preferred where their use is practical.

### In-memory capabilities holding NULL pointers

In conventional, integer-based architectures implement `NULL` pointers
integers with a value of `0`.
CHERI C/C++ similarly represents `NULL` as an all-zero capability value with
zero tag value.

This has a number of implications, including that zero-filled memory with
zeroed tag values will be interpreted as being `NULL`-filled, as is the case
with conventional architecture targets for C/C++.
This is particularly relevant for automatically initialized variable values
(such as global variables without specific initialization values), pre-zeroed
memory allocated by `calloc()`, or memory explicitly zeroed using
`memset(..., 0)`.
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
	assert(memcpy(&p, zeroes, sizeof(p)) == 0);
```
