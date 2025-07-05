### Generating string representations of capabilities

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
