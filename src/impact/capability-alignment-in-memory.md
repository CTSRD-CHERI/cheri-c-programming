### Capability alignment in memory

Because tags apply only to memory locations that are capability-aligned
and capability-sized,
unaligned storage of pointers will either generate a run-time
hardware exception (if a capability-aware load or store is performed), or discard the
tag (if a capability-oblivious memory copy is performed &mdash; e.g., using
`memcpy` to copy from an aligned location to an unaligned one).
One example of this is Berkeley DB (BDB) when used as an in-memory
implementation rather than as an on-disk database format.
Even when patched to use `memcpy` to copy objects stored as data, it
does not ensure sufficient alignment in its internal storage to preserve tags.
We therefore recommend against using BDB for this purpose.
While unaligned pointer use is uncommon in C programs, as data-structure
layouts are normally designed to keep them strongly aligned for performance
and atomicity reasons, any code depending on unaligned pointers will need
to be changed.

<!--
\amnote{Should we mention code that assumes that it is ok to go out of bounds
for optimization purposes? E.g., strcmp loading a word at a time?}
\psnote{yes}
-->
