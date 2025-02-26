## Loss of provenance

<!--
%\begin{compilerwarning}
%cast from provenance-free integer type to pointer type will give pointer that can not be dereferenced
%\end{compilerwarning}
-->

This common compiler warning<!--
\arnote{that should be an error by default?}
-->
is triggered when casting a non-capability type (e.g., `long`) to a pointer.
As mentioned in [Pointer provenance
validity](../impact/pointer-provenance-validity.html), the result of this cast is a `NULL`-derived capability with the address set to the integer value.
As any `NULL`-derived capability is untagged, any attempt to dereference it will trap.

Usually, this warning is caused by programmers incorrectly assuming that `long` is able to store pointers.
The fix for this problem is to change the type of the cast source to a provenance-carrying type such as `intptr_t` or `uintptr_t` (see [Recommended use of
C-language types](../impact/recommended-use-c-types.md)):

<!--
Need to use HTML formatting here for mdBook to get the highlight
colors in the code examples. The "id" attribute is required, because
we use that unique identifier in Pandoc to generate LaTeX highlight
formatting.
-->
<pre><code>char *example_bad(<mark id="BadParamTy" style="background-color: #EE918D">long</mark> ptr_or_int) {
    return strdup((const char *)ptr_or_int);
}
char *example_good(<mark id="GoodParamTy" style="background-color: #77DD77">intptr_t</mark> ptr_or_int) {
  return strdup((const char *)ptr_or_int);
}
</code></pre>


```{.compilerwarning}
<source>:2:17: warning: cast from provenance-free integer type to pointer type
will give pointer that can not be dereferenced [-Wcheri-capability-misuse]
  return strdup((const char *)ptr_or_int);
                ^
1 warning generated.
```

In some cases, this warning can be a false positive.
For example, it is common for C callback APIs take a `void *` data argument that is passed to the callback.
If this value is in fact an integer constant, the warning can be silenced by casting to `uintptr_t` first:

<!--
Need to use HTML formatting here for mdBook to get the highlight
colors in the code examples. The "id" attribute is required, because
we use that unique identifier in Pandoc to generate LaTeX highlight
formatting.
-->
<pre><code>void invoke_cb(void (*cb)(void *), void *);
void callback(void *arg);
void false_positive_example(int callback_data) {
    invoke_cb(&callback, (void *)callback_data); // warning
    invoke_cb(&callback, (void *)<mark id="SilenceProv" style="background-color: #77DD77">(uintptr_t)</mark>callback_data); // no warning
}
</code></pre>


```{.compilerwarning}
<source>:4:24: warning: cast from provenance-free integer type to pointer type
will give pointer that can not be dereferenced [-Wcheri-capability-misuse]
  invoke_cb(&callback, (void *)callback_data); // warning
                       ^
<source>:15:24: warning: cast to 'void *' from smaller integer type 'int'
[-Wint-to-void-pointer-cast]
  invoke_cb(&callback, (void *)callback_data); // warning
                       ^
2 warnings generated.
```

<!--
\nwfnote{The ``:15:24'' above should also be ``:4:24''?}
-->
