{ pkgs, userName, ... }:

{
  hardware.graphics.enable = true;

  programs = {
    light.enable = true;
    dconf.enable = true;

    sway = {
      enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
        export NIXOS_OZONE_WL=1
      '';
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        brightnessctl
        grim
        wl-clipboard
        mako
        slurp
        sway-contrib.grimshot
      ];
    };
  };

  services = {
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
    udisks2.enable = true;
    gvfs.enable = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        qt6Packages.fcitx5-configtool
        fcitx5-gtk
        fcitx5-rime
      ];
    };
  };

  security = {
    rtkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      swaylock.enableGnomeKeyring = true;
    };
  };

  environment.loginShellInit = ''
    if [ "$USER" = "${userName}" ] && [ "$(tty)" = "/dev/tty1" ] && [ -z "$WAYLAND_DISPLAY" ]; then
      mkdir -p "$HOME/.local/state"
      exec sway > "$HOME/.local/state/sway.log" 2>&1
    fi
  '';

  xdg.portal.enable = true;

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
