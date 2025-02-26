## Underaligned capabilities

<!--
%\begin{compilerwarning}
%alignment (<N>) of '<type>' is less than the required capability alignment
%\end{compilerwarning}
-->

This warning is triggered when packed structures contain pointers.
As mentioned in [Restrictions in capability locations in memory](../impact/restrictions-in-capability-locations.md), pointers must always be aligned to the size of a CHERI capability (16 bytes for a 64-bit architecture).
This warning can be triggered by code that attempts to align pointers to at least 8 bytes (e.g., for compatibility between 32- and 64-bit architectures). For example:

<pre><code>struct AtLeast8ByteAlignedBad {
    void *data;
} __attribute__((packed, <mark id="BadAlignPacked" style="background-color: #EE918D">aligned(8)</mark>));
</code></pre>

```{.compilerwarning}
<source>:1:8: warning: alignment (8) of 'struct AtLeast8ByteAlignedBad' is
less than the required capability alignment (16) [-Wcheri-capability-misuse]
struct AtLeast8ByteAlignedBad {
       ^
<source>:1:8: note: If you are certain that this is correct you can silence
the warning by adding __attribute__((annotate("underaligned_capability")))
1 warning generated.
```

The simplest fix for this issue is to either increase alignment to be CHERI-compatible, or use a ternary expression to include `alignof(void *)`:

<pre><code><mark id="FixAlign1" style="background-color: #77DD77">#include &lt;stdalign.h&gt;</mark>
struct AtLeast8ByteAlignedGood {
    void *data;
} __attribute__((packed,aligned(<mark id="FixAlign2" style="background-color: #77DD77">alignof(void *) > 8 ? alignof(void *) : 8</mark>)));
</code></pre>

In the rare case that creating a potentially underaligned pointer is actually intended, the warning can be silence by adding a `annotate("underaligned_capability")` attribute:

<pre><code>struct UnderalignPointerIgnoreWarning {
    void *data;
} __attribute__((packed, aligned(4), <mark id="SilenceAlign" style="background-color: #77DD77">annotate("underaligned_capability")</mark>));
</code></pre>
