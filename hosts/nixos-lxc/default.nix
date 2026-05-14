{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.isContainer = true;

  systemd.suppressedSystemUnits = [
    "sys-kernel-debug.mount"
  ];
}
