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
      keybind = [ "alt+space=toggle_quick_terminal" ];
      quick-terminal-position = "top";
      quick-terminal-size = "35%,99%";
      quick-terminal-autohide = false;
      quick-terminal-keyboard-interactivity = "exclusive";
      background-opacity = 0.97;
    };
  };
}
