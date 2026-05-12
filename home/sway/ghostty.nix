{ ... }:

{
  xdg.configFile."ghostty/shaders/cursor_sweep.glsl".source = ../../assets/ghostty/cursor_sweep.glsl;

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "CaskaydiaCove Nerd Font";
      font-size = 14;
      theme = "Catppuccin Macchiato";
      custom-shader = "shaders/cursor_sweep.glsl";
      background-opacity = 0.98;
    };
  };
}
