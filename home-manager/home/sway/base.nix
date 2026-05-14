{pkgs, ...}: let
  fcitx5CandlelightThemes = pkgs.fetchFromGitHub {
    owner = "thep0y";
    repo = "fcitx5-themes-candlelight";
    rev = "653677b0454569f41c815b3d262a57e42c90ee05";
    hash = "sha256-dN77aUt1qkN177BZOfrT6O72Qp0J2jlM2mGNxI0cBnA=";
  };
in {
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
      ../../../assets/wallpapers/wallhaven-yq587d.png;
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

  xdg.configFile."fcitx5/conf/classicui.conf" = {
    force = true;
    text = ''
      Vertical Candidate List=False
      PerScreenDPI=True
      Font="Noto Sans CJK SC 13"
      Theme=macOS-dark
    '';
  };

  xdg.dataFile."fcitx5/themes/macOS-dark" = {
    force = true;
    source = "${fcitx5CandlelightThemes}/macOS-dark";
  };
}
