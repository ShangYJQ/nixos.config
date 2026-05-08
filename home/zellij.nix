{ unstable, ... }:

{
  programs.zellij = {
    enable = true;
    package = unstable.zellij;
    # enableFishIntegration = true;
    settings = {
      default_shell = "fish";
      pane_frames = false;
      show_startup_tips = false;

      session_serialization = false;

      theme = "catppuccin-macchiato";
    };
  };
}
