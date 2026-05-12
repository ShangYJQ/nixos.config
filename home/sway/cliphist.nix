{ ... }:

{
  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ "sway-session.target" ];
  };
}
