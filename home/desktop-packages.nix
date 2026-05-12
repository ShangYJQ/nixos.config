{ pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    # Desktop applications
    ghostty
    nautilus

    networkmanager # provides nmtui

    # Desktop utilities
    unstable.bluetui
    brightnessctl
    unstable.cava
    cliphist
    unstable.gdu
    hypridle
    unstable.hyprpicker
    unstable.libnotify
    pamixer
    unstable.pavucontrol
    playerctl
    unstable.s-tui
    swappy
    wl-clipboard
    wlsunset
    xdg-utils
  ];

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
    ];
  };
}
