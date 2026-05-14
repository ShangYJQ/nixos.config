{
  lib,
  unstable,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = unstable.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };

      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
    };
  };

  networking.useDHCP = lib.mkDefault true;
  services.qemuGuest.enable = true;
}
