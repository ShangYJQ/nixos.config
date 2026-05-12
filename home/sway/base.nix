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
      QT_IM_MODULE = "fcitx";
    };

    file."Pictures/Wallpapers/wallhaven-yq587d.png".source =
      ../../assets/wallpapers/wallhaven-yq587d.png;
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

  xdg.configFile."fcitx5/profile" = {
    force = true;
    text = ''
      [Groups/0]
      Name=Default
      Default Layout=us
      DefaultIM=pinyin

      [Groups/0/Items/0]
      Name=keyboard-us
      Layout=

      [Groups/0/Items/1]
      Name=pinyin
      Layout=

      [GroupOrder]
      0=Default
    '';
  };
}
