### Printing capabilities with the printf(4) API family

When using the `printf(3)` family of APIs, the `#` qualifier to the `p` format
string will cause additional architecture-specific information to be printed
about a pointer.
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
