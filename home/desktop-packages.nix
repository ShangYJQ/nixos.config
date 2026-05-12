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
    unstable.cliphist
    unstable.gdu
    unstable.hypridle
    unstable.hyprpicker
    unstable.libnotify
    pamixer
    unstable.pavucontrol
    playerctl
    unstable.s-tui
    unstable.swappy
    unstable.wl-clipboard
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
