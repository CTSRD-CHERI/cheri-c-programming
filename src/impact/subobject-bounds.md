### Opportunistic subobject bounds

CHERI C/C++ also supports opportunistically restricting the
bounds when a pointer is taken to a subobject &mdash; for example, an array
embedded within another structure that itself has been heap allocated.
Subject to limitations arising from imprecise bounds (see
[Bounds precision](../background/cheri-capabilities.md#bounds-precision)),
this will prevent an overflow on that array from affecting the remainder of
the structure, improving spatial safety.

Subobject bounds are not enabled by default as they may require additional source code changes
for compatibility, but can be enabled using the `-Xclang -cheri-bounds=subobject-safe` compiler flag.
This is an active area of research, with consideration being given to enabling
a subset of subobject bounds checks by default in the future due to the
measurable security benefit and relatively low adoption friction.

One example of C code that requires changes for subobject bounds is the `containerof`
pattern, in which pointer arithmetic on a pointer to a subobject is used to
recover a pointer to the container object &mdash; for example, as seen in the
widely used BSD `queue.h` linked-list macros or the generic C
hash-table implementation, `uthash.h`.

In these cases, an opt-out annotation can be applied to a given type, field or variable
that instructs the compiler to not tighten bounds when creating pointers to subobjects.
We currently define three opt-out annotations that can be used to allow
existing code to disable use of subobject bounds:

**Completely disable subobject bounds**: It is possible to annotate a typedef,
record member, or variable declaration with:

```{.clisting}
__attribute__((cheri_no_subobject_bounds))
```

to indicate that the compiler should not tighten bounds when taking the address or a C++ reference. In C++11/C20 mode this can also be spelled as `[[cheri::no_subobject_bounds]]`.

```{.clisting}
struct str {
    /*
     * Nul-terminated string array -- pointers taken to this subobject will
     * use the array's bounds, not those of the container structure.
     */
    char               str_array[128];

    /*
     * Linked-list entry element -- because of the additional attribute,
     * pointers taken to this subobject will use the container structure's
     * bounds, not those of the specific field.
     */
    struct list_entry  str_le __attribute__((cheri_no_subobject_bounds));
} str_instance;

void
fn(void)
{
    /* Struct pointer gets bounds of str_instance. */
    struct str *strp = &str_instance;

    /* Character pointer gets bounds of the subobject, not str_instance. */
    char *c = str_instance.str_array;

    /* Struct pointer gets bounds of str_instance, not the subobject. */
    struct list_entry *lep = &str_instance.str_le;
}
```

**Disable subobject bounds in specific expressions**:
It is also possible to opt out of bounds-tightening on a per-expression
granularity by casting to an annotated type:

```{.clisting}
char *foo(struct str *strp) {
    return (&((__attribute__((cheri_no_subobject_bounds))struct str *)
        strp)->str_array);
}
```

**Use remaining allocation size**:
In certain cases, the size of the subobject is not known, but we still know that data
before the field member will not be accessed (e.g., variable size array members
inside structs).
Pre-C99 code will declare such members as fixed-size arrays, which will cause
a hardware exception if the allocation does not grant access to that many bytes.
[^5]
To use the remaining allocation size instead of completely disabling bounds
(and thus protecting against buffer underflows) the annotation:

```{.clisting}
__attribute__((cheri_subobject_bounds_use_remaining_size))
```

can be used.
When targeting C++11/C20:

```{.clisting}
[[cheri::subobject_bounds_use_remaining_size]]
```

is also supported.
Examples of this pattern include FreeBSD's `struct dirent`, which uses
`char d_name[255]` for an array that is actually of variable size, with
the containing allocation (e.g., of the heap) being sized to allow additional
space for array entries regardless of size in the type definition.
For example:

```{.clisting}
struct message {
    int     m_type;

    /*
     * Variable-length character array -- because of the additional
     * attribute, pointers taken to this subobject will have a lower bound
     * at the first address of the array, but retain an upper bound of the
     * allocation containing the array, rather than 252 bytes higher.
     */
    char    m_data[252]
                 __attribute__((cheri_subobject_bounds_use_remaining_size));
};
```

The use of subobject bounds imposes additional compatibility constraints on
existing C and C++ code.
While we have not encountered many issues related to subobject bounds in
existing code, it does slightly increase the porting effort.

## Effects of imprecise bounds

Subobject bounds are considered *opportunistic* because it may not be possible
to prevent aliasing within the bounds of a subobject pointer without
disturbing the binary layout policy for containing structures to permit
greater alignment and padding.
This particularly affects larger objects embedded within otherwise short
structures, such as large buffers with a short header.
Furthermore, variable-size structures pose a challenge because their size is
determined at run-time and the code requires explicit changes to the layout and
at the point of allocation to ensure representability.

This is an active area of research.
The problem of subobject bounds imprecision is also found in other programming
patterns, where an allocation is subdivided into multiple chunks, without any
cooperation from the allocator. We refer to these patterns as
intra-allocation bounds.

There are multiple approaches to address subobject bounds imprecision.
In general, precise bounds can be achieved by separately heap
allocating storage for each imprecise structure member, rather than embedding
them in the same allocation. This has trade-offs with respect to the added
complexity of managing an additional allocation, as well as additional indirection.
In some limited cases, ordering structure fields can also assist with bounds
precision for subobjects.

In the future, new compiler modes may be supported that allow fail stops to
occur if non-aliasing is not achieved, or to implement required alignment and
padding additions -- which may have significant memory overheads.
We are exploring potential improvements to compiler warnings and errors to
assist developers in debugging structure layouts that may lead to imprecise
bounds, a fail stop, or potentially unacceptable memory overhead.

Bounds precision of variable-size structures is determined by the offset
and size of the last member. This is more complicated to address with
compile-time warnings, because the size is not known.
Multiple approaches are possible in this case as well.
One option is to continue best-effort for variable size structs, specifically
for the variable-size member, to maximise source code compatibility.
A compiler option could control the exact bounds behaviour for variable-size
structure members, so that the programmer can opt-in to the fail-open behaviour.
It also possible to introduce annotations on variable-size members that specify
the maximum expected size, so that the compiler can insert the appropriate
amount of padding.

Finally, note that variable-size structures can only exhibit bounds aliasing on
the base, because the variable-size member is necessarily at the end of the
structure and, assuming the allocator is well-behaved, any rounding on the top
will only alias with extra padding space that is already part of the
representability padding for the whole allocation.

[^5]: If flexible arrays members are declared using the C99 syntax with empty
square brackets, the compiler will automatically use the remaining allocation
size.

