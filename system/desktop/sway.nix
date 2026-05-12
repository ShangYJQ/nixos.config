{
  config,
  lib,
  pkgs,
  unstable,
  userName,
  ...
}:

let
  swayCommand = lib.getExe config.programs.sway.package;
in
{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    graphics.enable = true;
  };

  programs = {
    dconf.enable = true;

    sway = {
      enable = true;
      package = unstable.sway;
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export WLR_NO_HARDWARE_CURSORS=1
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export NIXOS_OZONE_WL=1
        export ELECTRON_OZONE_PLATFORM_HINT=auto

        # Prefer the AMD iGPU for wlroots, while still exposing the NVIDIA dGPU outputs.
        sway_drm_devices=""
        for sway_drm_device in /dev/dri/by-path/pci-0000:06:00.0-card /dev/dri/by-path/pci-0000:01:00.0-card; do
          if [ -e "$sway_drm_device" ]; then
            sway_drm_device="$(${pkgs.coreutils}/bin/realpath "$sway_drm_device")"
            sway_drm_devices="$sway_drm_devices''${sway_drm_devices:+:}$sway_drm_device"
          fi
        done
        if [ -n "$sway_drm_devices" ]; then
          export WLR_DRM_DEVICES="$sway_drm_devices"
        fi
      '';
      wrapperFeatures.gtk = true;
      extraPackages = [ ];
    };
  };

  services = {
    xserver.desktopManager.runXdgAutostartIfNone = false;

    gnome.gnome-keyring.enable = true;

    getty = {
      autologinUser = userName;
      autologinOnce = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    pulseaudio.enable = false;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
  };

  security = {
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            action.id == "org.freedesktop.UPower.PowerProfiles.switch-profile" &&
            subject.user == "${userName}"
          ) {
            return polkit.Result.YES;
          }
        });
      '';
    };

    rtkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      swaylock.enableGnomeKeyring = true;
    };
  };

  programs.fish.loginShellInit = ''
    if test "$USER" = "${userName}"; and test (tty) = /dev/tty1; and not set -q WAYLAND_DISPLAY
      mkdir -p "$HOME/.local/state"
      exec ${swayCommand} > "$HOME/.local/state/sway.log" 2>&1
    end
  '';

  xdg.portal = {
    enable = true;
    wlr.enable = lib.mkForce false;
    extraPortals = [
      unstable.xdg-desktop-portal-wlr
    ];
    config = {
      common.default = [
        "wlr"
        "gtk"
      ];
      sway.default = lib.mkForce [
        "wlr"
        "gtk"
      ];
    };
  };

  users.users.${userName}.extraGroups = [ "video" ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      font-awesome
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
    ];

    fontconfig.defaultFonts = {
      monospace = [
        "CaskaydiaCove Nerd Font"
        "JetBrainsMono Nerd Font"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
