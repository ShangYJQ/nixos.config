{
  awwwPackage,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    # Desktop applications
    ghostty
    google-chrome
    nautilus

    mntui

    # Desktop utilities
    awwwPackage
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
