{
  awwwPackage,
  config,
  lib,
  pkgs,
  ...
}:

let
  swayShared = import ./shared.nix {
    inherit
      awwwPackage
      config
      lib
      pkgs
      ;
  };
in
{
  xdg.configFile."awww/wallpaper.sh" = {
    source = swayShared.wallpaperScript;
    executable = true;
  };
}
