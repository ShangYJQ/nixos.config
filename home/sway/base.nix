{ pkgs, ... }:

{
  home = {
    packages = [
      pkgs.bibata-cursors
    ];

    pointerCursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;

      x11 = {
        enable = true;
        defaultCursor = "Bibata-Modern-Classic";
      };

      sway.enable = true;
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    file."Pictures/Wallpapers/wallhaven-yq587d.png".source =
      ../../assets/wallpapers/wallhaven-yq587d.png;
  };
}
