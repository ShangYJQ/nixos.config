{lib, ...}: {
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "xhci_pci"
    "usbhid"
    "sd_mod"
  ];

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

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
