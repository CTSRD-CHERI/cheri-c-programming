## Modifying or restricting capability properties

The following APIs allow capability properties to be refined on pointers:

* **`void *cheri_address_set(void *c, ptraddr_t a)`**: Return a new capability with the same permissions and bounds as `c` with the address set to `a`.
This can be useful to re-derive a valid pointer from an address.

  `cheri_address_set` is able to set an address `a` that is
  outside of the current bounds of `c`.  The resulting capability
  is treated as an out-of-bounds pointer as described in [Out-of-bounds
  pointers](../impact/out-of-bounds-pointers.html).
  However, if the address `a` is not representable in the current
  bounds of `c` due to capability compression,
  `cheri_address_set` returns a capability without the tag bit set.

<!--
  %  This macro wraps the compiler built-in
  %  `__builtin_cheri_address_set`.
-->

* **`void *cheri_bounds_set(void *c, size_t x)`**: Narrow the bounds of capability
  `c` so that the lower bound is the current address (which may
  have been increased relative to `c`'s original lower bound), and its
  upper bound is suitable for a length of `x`.

  Note that the effective bounds of the returned capability may be
  wider than the range [`cheri_address_get(c)`,
  `cheri_address_get(c) + x`) due to capability compression (see
  [Bounds alignment due to
  compression](../apis/bounds-alignment-due-to-compression.html)),
  but they will always be a subset of
  the original bounds. <!--% of `c`.-->

* **`void *cheri_bounds_set_exact(void *c, size_t x)`**: Narrow the bounds of capability
  `c` so that the lower bound is the current address, and its
  upper bound is `cheri_address_get(c) + x`.
  This is similar to `cheri_bounds_set` but will raise a hardware exception if the resulting capability is not precisely representable instead of rounding the bounds.

<!--
\nwfnote{No mention of cheri\_bounds\_set\_exact?}
-->

* **`void *cheri_perms_and(void *c, size_t x)`**: Perform a bitwise-AND of capability
  `c`'s permissions and the value `x`, returning the new
  capability (see [Capability permissions](capability-permissions.html)).

<!--
  %  This macro wraps the compiler built-in
  %  `__builtin_cheri_perms_and`.
-->

* **`void *cheri_tag_clear(void *c)`**: Clear the tag on `c`, returning the
  new capability.

<!--
  % \note{Are the references to the `__builtin_` forms useful?  Do we
  % want to encourage their use or the `cheric.h` macros?}{nwf}
-->
