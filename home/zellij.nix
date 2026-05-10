{ unstable, ... }:

{
  programs.zellij = {
    enable = true;
    package = unstable.zellij;
    # enableFishIntegration = true;
    # exitShellOnExit = true;

    extraConfig = ''
      keybinds {
          normal {
              bind "Ctrl Shift Left"  { GoToPreviousTab; }
              bind "Ctrl Shift Right" { GoToNextTab; }
          }

          locked {
              bind "Ctrl Shift Left"  { GoToPreviousTab; }
              bind "Ctrl Shift Right" { GoToNextTab; }
          }
      }
    '';

    settings = {
      default_shell = "fish";
      pane_frames = false;
      show_startup_tips = false;

      session_serialization = false;

      theme = "catppuccin-macchiato";
    };
  };
}
