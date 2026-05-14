{
  config,
  lib,
  pkgs,
  unstable,
  ...
}: let
  swayShared = import ./shared.nix {
    inherit
      config
      lib
      pkgs
      unstable
      ;
  };
in {
  services.mako = {
    enable = true;
    package = unstable.mako;
    settings = {
      anchor = "top-right";
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#646789";
      border-radius = 0;
      default-timeout = 5000;
      width = 420;
      outer-margin = 20;
      padding = "10,15";
      border-size = 2;
      max-icon-size = 32;
      font = "CaskaydiaCove Nerd Font Propo 16px";

      "urgency=low".on-notify = "exec ${swayShared.makoNotifySound} low";
      "urgency=normal".on-notify = "exec ${swayShared.makoNotifySound} normal";
      "urgency=high".on-notify = "exec ${swayShared.makoNotifySound} critical";
    };
  };
}
