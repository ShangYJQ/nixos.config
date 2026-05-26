{ ... }:
{
  imports = [
    ./windlab.nix
  ];

  boot.isContainer = true;

  systemd.suppressedSystemUnits = [
    "sys-kernel-debug.mount"
  ];
}
