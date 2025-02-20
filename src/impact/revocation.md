## Implications of capability revocation for temporal safety

Heap temporal safety utilizes revocation sweeps, which, after some quarantine
period, replace in-register and in-memory capabilities to freed memory with
non-dereferenceable values.
For performance reasons, that replacement may be substantially deferred, or,
if there is little demand for fresh allocations, may never occur.
Pointer value replacement may also permit some instances of
a pointer to continue to be usable for longer than others, but the referenced
memory will not be reallocated or otherwise reused until all instances have been rendered unusable.
This model does permit non-exploitable *use-after-free* of heap memory,
but prohibits exploitable memory aliasing by disallowing *use-after-reallocation*.

A pointer's value after `free` is undefined, and so dereference is
an undefined behavior.
In practice, however, the value of a `free`-d pointer may still be
observed in a number of situations, including in lockless algorithms, which
may compare an allocated pointer to a freed one.

Our systems have a choice of replacement values for revoked pointers; all that
is required for correct temporal safety is that the replacement not authorize
access to memory.
Our prototype implementation clears the tag when replacing, as this
certainly removes authority and possibly simplifies debugging and
non-dereferencing operations, as the original capability bits are left behind.
For example, pointer equality checks that compare only the addresses of the two
pointers (and not their tag values) will continue to work as expected.  With
revocation performed this way, software making explicit use of tags must be
designed to tolerate capability tag clearing by revocation.

Unfortunately, tag-clearing risks type confusion if programmers intend to use
the capability tag to distinguish between integers and pointers in tagged
unions (we have so far generally discouraged this idea, but understand why it
may remain attractive).  Therefore, we have considered other options for
revocation, including tag-preserving *permission*-zeroing (but tag
preservation) and wholesale replacement with `NULL` (i.e., the untagged
all zero value).  These options may be more attractive for some software, and
would have different implications for the C/C++ programming model.

We anticipate that revocation will remain a tag-clearing operation by default,
as tag-clearing removes any risk of needlessly re-examining the capability in
later revocations.  However, it may be possible to allow coarse control over
revocation behavior either per process or by region of the address space.  In
the latter case, `mmap` may gain flags specifying which revocation
behavior is desirable for capabilities pointing *into* the mapped region
and/or `madvise` may gain flags controlling the revocation behavior of
capabilities *within* a target region.  Which of these or similar
mechanisms provide utility to software and can be offered at reasonable
performance remains an open question.
