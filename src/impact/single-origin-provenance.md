### Single-origin provenance
<!--
\label{sec:ambiguous-provenance}
-->

In the CHERI memory protection model, capabilities are derived from a single other
capability.
However, in C code, expressions may construct a new `intptr_t` value from more
than one provenance-carrying parent `intptr_t` &mdash; for example, by casting both a
pointer and a literal value to `intptr_t`-s, and then adding them. <!--
\psnote{That literal value wouldn't have a non-empty provenance, so this isn't the best example.   Maybe better to have something like \texttt{p+(q1-q2)} ?}
\psnote{More generally, there is a bit of a mismatch between this and our C provenance treatment of \cintptrt, which there is a plain integer type with no provenance &mdash; but which regains provenance in some cases when cast back to a pointer.  To ponder...}
-->
In that case, the compiler must decide which input capability provides the
capability metadata (bounds, permissions, ...) to be used in the output
value.
Consider for example the following code:

```{.clisting}
void *c1 = (void *)((uintptr_t)input_ptr + 1);
void *c2 = (void *)(1 + (uintptr_t)input_ptr);
uintptr_t offset = 1;
void *c3 = (void *)(offset + (uintptr_t)input_ptr);
```

In C with integer pointers, the values of `c1`, `c2`, and `c3` might be expected to have the
same value as `input_ptr`, except with the address incremented by one.
In CHERI C, each expression includes an arithmetic operation between provenance-carrying types.
While not visible in the source code, the constant `1` is promoted to a capability type, `uintptr_t`.
In the current implementation, the compiler will return the expected provenance-carrying result for cases `c1` and `c2` but not `c3`.[^2]

For `c1` and `c2`, the compiler sees that one of the sides is a non-provenance-carrying integer type that was promoted to `uintptr_t` and therefore selects the other operand as the provenance source.
It is not feasible to infer the correct provenance source for the third case, so the compiler will emit a warning.[^3]

The current behavior for such ambiguous cases is to select the left-hand-side as the provenance source, but we are considering making this an error in the future.

The recommended approach to resolve such ambiguous cases is to change the type of one operand to a non-provenance-carrying type such as `size_t`.
Alternatively, if the variable declaration cannot be changed, it is also possible to use a cast in the expression itself.

```{.clisting}
size_t offset_size_t = 1;
void *c3_good1 = (void *)(offset_size_t + (uintptr_t)input_ptr);

uintptr_t offset_uintptr_t = 1;
void *c3_good2 = (void *)((size_t)offset_uintptr_t + (uintptr_t)input_ptr);
```

We also provide a new attribute `cheri_no_provenance` that can be used to annotate variables or fields of type `intptr_t`/`uintptr_t` where the underlying type cannot be changed:

```{.clisting}
struct S {
    uintptr_t maybe_tagged;
    uintptr_t never_tagged __attribute__((cheri_no_provenance));
}
void test(struct S s, uintptr_t ptr) {
    void *x1 = (void *)(s.maybe_tagged + ptr); // ambiguous, currently uses LHS
    void *x2 = (void *)(s.never_tagged + ptr); // not ambiguous, uses RHS
}
```

<!--
\psnote{This doesn't really explain what `cheri_no_provenance` does?  And what it means when applied to other types?}\arnote{compiler error if it's not \cuintptrt. Will try to improve example later.}
-->

[^2]: Historically, the CHERI compiler would select the left-hand-most pointer in the expression as the provenance source.
While this model follows a single consistent rule, it can lead to surprising behavior if an expression places the provenance-carrying value to the right-hand-side.
In the example above, the value of `c1` would be a valid capability, but `c2` and `c3` would hold an untagged value (albeit with the expected address).

[^3]: We could add a data-flow-sensitive analysis to determine whether values are the result of promotion from a non-provenance-carrying type.
However, this would add significant complexity to the compiler and we have not seen many cases where this would have avoided changes to the source code.
<!--
\psnote{from a language-design POV, it'd be pretty horrid to have substantial semantics depend on just how smart one's analysis is}
\arnote{I agree. Even the current behavior is quite ugly, but at least it has measurable compatibility benefits.}
-->
