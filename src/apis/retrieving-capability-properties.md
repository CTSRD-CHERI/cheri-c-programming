# Retrieving capability properties

The following APIs allow capability properties to be retrieved from pointers:

* `ptraddr_t cheri_address_get(void *c)`: Return the address of the capability `c`.

* `ptraddr_t cheri_base_get(void *c)`: Return the lower bound of capability `c`.

* `size_t cheri_length_get(void *c)`: Return the length of the bounds for the capability `c`.
  The base plus the length gives the upper bound on `c`'s address.

* `size_t cheri_offset_get(void *c)`: Return the difference between the address and the lower bound of the capability `c`.

* `size_t cheri_perms_get(void *c)`: Return the permissions of capability `c`.
  (See \Cref{sec:capability_permissions}.)

* `_Bool cheri_tag_get(void *c)`: Return whether capability `c` has its
  validity tag set.

<!--
  \arnote{This returns the raw tag value, cheriintrin.h may also provide `cheri_is_valid` and `cheri_is_invalid`}
-->
