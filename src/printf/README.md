## Printing capabilities from C

Capability pointers carry additional metadata that it can sometimes be useful
to print to a human readable string.
CHERI C/C++ defines a decoded string format for capabilities, which may be
accessed indirectly via existing C APIs such as `printf(3)`, `snprintf(3)`, or
directly via calls to the `strfcap(3)` function itself.

### strfcap(3)

```
ssize_t
     strfcap(char * restrict buf, size_t maxsize,
         const char * restrict format, uintcap_t cap);
```

The `strfcap(3)` API accepts multiple arguments:

 * `buf` is a target character buffer for the resulting generated string.
 * `maxsize` is the size of the target character buffer.
 * `format` is a string containing zero or more conversion specifiers or
   ordinary characters.
 * `cap` is the capability to decode.

The return value is the number of characters that would have been printed if
`size were unlimited, excluding the trailing nul terminator.
A negative value is returned on failure.

Various format specifiers, documented in the [CheriBSD `strfcap(3)` man
page](https://man.cheribsd.org/cgi-bin/man.cgi/strfcap.3), include various
individual field specifiers for capability metadata such as its address,
attributes, base address, length, offset, permissions, and so on.
The `%C` format string will print out capabilities with the following format
`%#xa [%P,%#xb-%%xt]%? %A`:

 * `%xa`: Hex formatted capability address
 * `%P`: Abbreviated human-readable capability permissions
 * `%xb`: Hex formatted capability base
 * `%xt`: Hext-formatted capability top address
 * `%A`: Textual representation of capability attributes, such as `invalid` or `sentry`

For example, the `strfcap(3)` output `0x130b60 [rwRW,0x130b60-0x130b64]`
describes a capability whose:

 * Capability address is `0x130b60`
 * Capability permissions are `rwRW` (can read and write both data and
   capabilities)
 * Capability base address is `0x130b60`
 * Capability top address is `0x130b64`
 * Has a valid tag
 * Is not sealed

The `strfcap(3)` man page should be referenced for full details.

### printf(3)

When using `printf(3)`, the `#` qualifier to the `p` format string will cause
additional architecture-specific information to be printed about a pointer.
In CHERI C/C++, this prints out capability metadata as rendered using
`strfcap(3)`'s `%C` format string.
For example, the following code fragment:

```
int foo;
...
        printf("%%p:\t%p\n", &foo);
        printf("%%#p:\t%#p\n", &foo);
```

Will print out the following output in CheriBSD's CheriABI:

```
%p:	0x130b60
%#p:	0x130b60 [rwRW,0x130b60-0x130b64]
```
