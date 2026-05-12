{ lib, pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    systemdTarget = "sway-session.target";
    settings = {
      general = {
        lock_cmd = "${lib.getExe pkgs.swaylock} -f";
        before_sleep_cmd = "${lib.getExe pkgs.swaylock} -f";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "${lib.getExe pkgs.swaylock} -f";
        }
        {
          timeout = 1200;
          on-timeout = "${lib.getExe' pkgs.sway "swaymsg"} \"output * dpms off\"";
          on-resume = "${lib.getExe' pkgs.sway "swaymsg"} \"output * dpms on\"";
        }
      ];
    };
  };
}
