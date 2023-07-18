# Ambiguous provenance

For arithmetic and bitwise binary operations between `uintptr_t`/`intptr_t`, the compiler can generally infer which side of the expression should be used as the provenance (and bounds) source.
However, as noted in [Single-origin provenance](../impact/single-origin-provenance.html), there are cases that are ambiguous as far as the compiler is concerned.

Consider for example a structure that holds a pointer and a small number of flags.
In this case the pointer is known to be aligned to at least 8 bytes, so the programmer uses the lowest 3 bits to store additional data:

```
\begin{clisting}[numbers=left]
typedef struct { uintptr_t data; } pointer_and_flags;
void set_ptr(pointer_and_flags *p, void *value) {
    p->data = (p->data & (uintptr_t)7) | (uintptr_t)(value);
}
void set_flags(pointer_and_flags *p, unsigned flags) {
    p->data = p->data | (flags & 7);
}
```

```
<source>:3:40: warning: binary expression on capability types '__uintcap_t' and 'uintptr_t' (aka '__uintcap_t'); it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side [-Wcheri-provenance]
    p->data = (p->data & (uintptr_t)7) | (uintptr_t)(value);
              ~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~
1 warning generated.
```

Unlike the compiler, the programmer knows that inside ```set_ptr``` capability metadata should always be taken from the `value` argument.
The suggested fix for this problem is fix is to cast the non-pointer argument to an integer type:

<!--
\TikzListingHighlightStartEnd[green]{FixAmbig}
-->
```
void set_ptr(pointer_and_flags *p, void *value) {
    p->data = £\vcpgfmark{StartFixAmbig}£(size_t)£\vcpgfmark{EndFixAmbig}£(p->data & (uintptr_t)7) | (uintptr_t)(value);
}
```

<!--
\nwfnote{Not use cheri\_low\_bits\_set()?}
-->

<!--
\arnote{TODO: this section should have more examples.}
-->
