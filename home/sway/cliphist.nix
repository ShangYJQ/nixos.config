{ unstable, ... }:

{
  services.cliphist = {
    enable = true;
    package = unstable.cliphist;
    allowImages = true;
    systemdTargets = [ "sway-session.target" ];
  };
}
