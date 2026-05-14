{
  lib,
  pkgs,
  unstable,
  ...
}: {
  services.swayidle = {
    enable = true;
    package = unstable.swayidle;
    systemdTarget = "sway-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${lib.getExe unstable.swaylock} -f";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "${lib.getExe unstable.swaylock} -f";
      }
      {
        timeout = 1200;
        command = "${lib.getExe' unstable.sway "swaymsg"} \"output * dpms off\"";
        resumeCommand = "${lib.getExe' unstable.sway "swaymsg"} \"output * dpms on\"";
      }
    ];
  };
}
