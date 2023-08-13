# Introduction

This document is a brief introduction to the CHERI C/C++
programming languages, which employ CHERI's architectural capability
primitive to implement C/C++-language memory safety.
We explain the principles underlying these language variants, and their
grounding in CHERI's multiple architectural instantiations:
CHERI-MIPS, CHERI-RISC-V, and Arm's Morello.
We describe the most commonly encountered differences between these
dialects and C/C++ on conventional architectures, and where existing
software may require minor changes.
We document new compiler warnings and errors that may be experienced compiling
code with the CHERI Clang/LLVM compiler, and suggest how they may be addressed
through typically minor source-code changes.
We explain how modest language extensions allow selected software, such
as memory allocators, to further refine permissions and bounds on pointers.
This guidance is based on our experience adapting the FreeBSD operating-system
userspace, and applications such as PostgreSQL and WebKit, to run in a
CHERI C/C++ capability-based programming environment.
We conclude by recommending further reading.
