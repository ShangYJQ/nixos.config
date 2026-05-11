{ lib, modulesPath, ... }:

{

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_blk"
      "virtio_scsi"
      "xhci_pci"
      "usbhid"
      "sd_mod"
    ];

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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  networking.useDHCP = lib.mkDefault true;
  services.qemuGuest.enable = true;
}
