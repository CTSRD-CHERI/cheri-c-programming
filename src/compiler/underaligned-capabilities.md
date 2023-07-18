# Underaligned capabilities

<!--
%\begin{compilerwarning}
%alignment (<N>) of '<type>' is less than the required capability alignment
%\end{compilerwarning}
-->

This warning is triggered when packed structures contain pointers.
As mentioned in \cref{sec:restricted-capability-locations}, pointers must always be aligned to the size of a CHERI capability (16 bytes for a 64-bit architecture).
This warning can be triggered by code that attempts to align pointers to at least 8 bytes (e.g., for compatibility between 32- and 64-bit architectures). For example:

<!--
\TikzListingHighlightStartEnd[red]{BadAlignPacked}
-->

```
struct AtLeast8ByteAlignedBad {
    void *data;
} __attribute__((packed, £\vcpgfmark{StartBadAlignPacked}£aligned(8)£\vcpgfmark{EndBadAlignPacked}£));
```

```
<source>:1:8: warning: alignment (8) of 'struct AtLeast8ByteAlignedBad' is less than the required capability alignment (16) [-Wcheri-capability-misuse]
struct AtLeast8ByteAlignedBad {
       ^
<source>:1:8: note: If you are certain that this is correct you can silence the warning by adding __attribute__((annotate("underaligned_capability")))
1 warning generated.
```

The simplest fix for this issue is to either increase alignment to be CHERI-compatible, or use a ternary expression to include `alignof(void *)`:

```
£\vcpgfmark{StartFixAlign1}£#include <stdalign.h>£\vcpgfmark{EndFixAlign1}£
struct AtLeast8ByteAlignedGood {
    void *data;
} __attribute__((packed,aligned(£\vcpgfmark{StartFixAlign2}£alignof(void *) > 8 ? alignof(void *) : 8£\vcpgfmark{EndFixAlign2}£)));
```

<!--
\TikzListingHighlightStartEnd[green]{FixAlign1}
\TikzListingHighlightStartEnd[green]{FixAlign2}
-->
In the rare case that creating a potentially underaligned pointer is actually intended, the warning can be silence by adding a `annotate("underaligned_capability")` attribute:

<!--
\TikzListingHighlightStartEnd[green]{SilenceAlign}
-->

```
struct UnderalignPointerIgnoreWarning {
    void *data;
} __attribute__((packed, aligned(4), £\vcpgfmark{StartSilenceAlign}£annotate("underaligned_capability")£\vcpgfmark{EndSilenceAlign}£));
```
