{
  lib,
  unstable,
  ...
}:

{

  imports = [
    ../hardware-configuration.nix
    ../modules/sway.nix
  ];

  boot = {
    kernelPackages = unstable.linuxPackages_latest;

    loader = {
      systemd-boot.enable = false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      limine = {
        enable = true;
        efiSupport = true;
        enableEditor = false;
        maxGenerations = 10;
        extraEntries = ''
          /Windows Boot Manager
            comment: Boot Windows from the existing Windows EFI partition
            protocol: efi
            path: guid(5ae7abec-21f4-474e-b551-32b7b9f26e0d):/EFI/Microsoft/Boot/bootmgfw.efi
        '';

        style = {
          wallpapers = [ ../assets/wallpapers/wallhaven-yq587d.png ];
          wallpaperStyle = "stretched";
          backdrop = "1E1E2E";

          interface = {
            resolution = "2560x1440";
            branding = "NixOS";
            brandingColor = 5;
            helpHidden = true;
          };

          graphicalTerminal = {
            foreground = "CDD6F4";
            background = "CC1E1E2E";
            brightForeground = "BAC2DE";
            brightBackground = "CC313244";
            palette = "11111B;F38BA8;A6E3A1;F9E2AF;89B4FA;CBA6F7;89DCEB;BAC2DE";
            brightPalette = "45475A;F38BA8;A6E3A1;F9E2AF;89B4FA;CBA6F7;89DCEB;CDD6F4";
          };
        };
      };
    };

  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  networking.useDHCP = lib.mkDefault true;
}
