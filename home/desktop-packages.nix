{ pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    # Desktop applications
    ghostty
    google-chrome
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
    unstable.walker
    wl-clipboard
    wlsunset
    xdg-utils
  ];
}
