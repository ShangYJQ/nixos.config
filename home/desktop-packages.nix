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
