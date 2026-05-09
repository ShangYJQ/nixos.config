{ ... }:

{
  programs.fastfetch = {
    enable = true;

    settings = {
      display.separator = " ";

      modules = [
        "break"
        {
          format = "{user-name}@{host-name}";
          key = "╭─";
          keyColor = "magenta";
          type = "title";
        }
        {
          key = "├─";
          keyColor = "magenta";
          type = "os";
        }
        {
          key = "├─";
          keyColor = "magenta";
          type = "kernel";
        }
        {
          key = "├─󰏖";
          keyColor = "magenta";
          type = "packages";
        }
        {
          key = "╰─󰅐";
          keyColor = "magenta";
          type = "uptime";
        }
        "break"
        {
          key = "╭─󰻠";
          keyColor = "green";
          type = "cpu";
        }
        {
          key = "├─󰌢";
          keyColor = "green";
          type = "host";
        }
        {
          key = "├─󰍹";
          keyColor = "green";
          type = "display";
        }
        {
          key = "├─󰍛";
          keyColor = "green";
          type = "gpu";
        }
        {
          key = "├─";
          keyColor = "green";
          type = "disk";
        }
        {
          key = "├─󰑭";
          keyColor = "green";
          type = "memory";
        }
        {
          key = "╰─󰓡";
          keyColor = "green";
          type = "swap";
        }
        "break"
        {
          key = "╭─";
          keyColor = "yellow";
          type = "shell";
        }
        {
          key = "├─";
          keyColor = "yellow";
          type = "terminal";
        }
        {
          key = "├─󰧨";
          keyColor = "yellow";
          type = "lm";
        }
        {
          key = "├─";
          keyColor = "yellow";
          type = "wm";
        }
        {
          key = "├─";
          keyColor = "yellow";
          type = "font";
        }
        {
          key = "├─󰉼";
          keyColor = "yellow";
          type = "theme";
        }
        {
          key = "├─󰀻";
          keyColor = "yellow";
          type = "icons";
        }
        {
          key = "╰─";
          keyColor = "yellow";
          symbol = "circle";
          type = "colors";
        }
      ];
    };
  };
}
