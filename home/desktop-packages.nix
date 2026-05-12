{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Desktop applications
    ghostty
    google-chrome
    nautilus

    networkmanager # provides nmtui

    # Desktop utilities
    bluetui
    brightnessctl
    cava
    cliphist
    gdu
    hypridle
    hyprpicker
    libnotify
    pamixer
    pavucontrol
    playerctl
    s-tui
    swappy
    walker
    wl-clipboard
    wlsunset
    xdg-utils
  ];
}
