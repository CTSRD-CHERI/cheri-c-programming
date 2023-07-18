# Data-structure and memory-allocation alignment

CHERI C/C++ have stronger alignment requirements than C/C++ on conventional
architectures.
These requirements arise from two sources: that capabilities themselves must
be aligned at twice the integer architectural pointer width, and that
capability compression constrains the addresses that can be used for bounds
on larger objects.

<!--
\amnote{Is is worth mentioning compiler flags to warn on excessive padding?
  In particular, it seems that it is often the case that the ordering of
  struct elements that was devised for 32bit and 64bit architectures does
  not help much to avoid extra padding with capabilities. It more or less
  depends on how much the pointers are scattered in the struct definition.}
-->
