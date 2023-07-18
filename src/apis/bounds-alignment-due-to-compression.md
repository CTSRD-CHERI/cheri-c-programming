# Bounds alignment due to compression

<!--
\label{sec:bounds_alignment}
-->

Bounds imprecisions may require a memory allocator to increase the alignment
of an allocation, or increase padding on an allocation, to prevent bounds from
spanning more than one object.
When the length of an object exceeds *2^(floor(bounds_bits/2)-1)* (i.e., 4 KiB for CHERI-MIPS and 64-bit CHERI-RISC-V), additional alignment requirements
apply to the lower and upper bounds.
The alignment required for allocations exceeding the minimum representable range (4 KiB for CHERI-MIPS and 64-bit CHERI-RISC-V) is *2^(E+3)* bytes, where
*E* is determined from the length, *l*, by
*E = 52 - CountLeadingZeros(l[64:floor(bounds_bits/2)])*.

<!--
\arnote{Is this too much detail?}
-->

<!--
%\jrtcnote{Do we want to clarify that this is a 65-bit length? One would naively
%expect it to be 64-bit and thus be off by one in all calculations. We should
%probably also steer people towards CRRL/CRAM regardless (and add cheri\_foo
%APIs for them).}
%\arnote{65-bit length is probably too much detail. But CRRL/CRAM now documented}
-->

Correctly computing the rounded size and minimum alignment for a given
allocation is non-trivial and may require many instructions to compute,
especially in the context of fast allocators such as the stack allocator.
Moreover, the architectural constants used for bounds precision differ across
architectures or their variations, and so alignment constraints also vary.
For example, the number of bits available for bounds differs between 32-bit and
64-bit CHERI-RISC-V, and also between 64-bit CHERI-RISC-V and Morello.

To avoid overly specific software knowledge of alignment requirements, and also to allow efficient calculation of alignment constraints during (for example) stack allocation, the CHERI ISA provides instructions that allow determining precisely representable allocations.
These instructions can be generated using compiler builtins that are provided by `cheriintrin.h`:

* `size_t cheri_representable_length(size_t len)`: returns the length that a capability would have after using `cheri_bounds_set` to set the length to `len` (assuming appropriate alignment of the base).

* `size_t cheri_representable_alignment_mask(size_t len)`: returns a bitmask that can be used to align an address downwards such that it is sufficiently aligned to create a precisely bounded capability.

The precisely representable base address can be computed using:

```
base = base & cheri_representable_alignment_mask(len);
```

When allocating from a contiguous buffer, the base needs to be aligned upwards instead of downwards.
This can be done with the following code:

```
size_t required_alignment(size_t len) {
    return ~cheri_representable_alignment_mask(len) + 1;
}
struct Buffer {
    void *data;
    size_t allocated;
};
void *allocate_next(struct Buffer *buf, size_t len) {
    char *result = buf->data + buf->allocated;
    result = __builtin_align_up(result, required_alignment(len));
    size_t rounded_len = cheri_representable_length(len);
    buf->allocated = (result + rounded_len) - (char *)buf->data;
    return cheri_bounds_set_exact(result, rounded_len);
}
```

Software written to use these compiler builtins, rather than encoding alignment
requirements directly, is more likely to be portable between CHERI-MIPS,
CHERI-RISC-V, and Morello.
