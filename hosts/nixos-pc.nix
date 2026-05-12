{
  lib,
  unstable,
  ...
}:

{

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = unstable.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

  };

  networking.useDHCP = lib.mkDefault true;
}
