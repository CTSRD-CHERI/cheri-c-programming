# Capability permissions

<!--
\label{sec:capability_permissions}
-->

A number of capability permissions are available for use; only those relating
to CHERI memory protection are enumerated here:

* `CHERI_PERM_EXECUTE`: Authorize instruction fetch via this
   capability.

* `CHERI_PERM_LOAD`: Authorize data load via this capability.

* `CHERI_PERM_LOAD_CAP`: Authorize capability load via this capability.
  If the permission is not present, the tag on the loaded value
  will be silently cleared.

* `CHERI_PERM_STORE`: Authorize data store via this capability.

* `CHERI_PERM_STORE_CAP`: Authorize capability store via this capability.
  If the permission is not present, and the tag on the stored capability is
  valid, then a hardware exception will be thrown.

In addition to architectural permissions, CHERI capabilities have
software-defined permissions.
CheriBSD defines the following additional memory-protection-related
permission:

* `CHERI_PERM_CHERIABI_VMMAP`: A CheriABI-specific user
  permission that the kernel uses to authorize modifications to
  virtual-memory mappings.
  If the permission is not present, system calls that alter the contents
  or the presentation of memory mappings will reject the request.
  As this is a CheriBSD-specific permission, it is not defined in
  `cheriintrin.h` and requires inclusion of `cheri/cheri.h`.
