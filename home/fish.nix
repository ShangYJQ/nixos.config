{ unstable, ... }:

{
  programs.fish = {
    enable = true;
    package = unstable.fish;

    shellAbbrs = {
      qkgit = "git add .; and aicommits -y; and git push";
      gpl = "git pull";
      gph = "git push";
      g2p = "git pull; and git push";
      ga = "git add .";
      gr = "git restore .";
      gs = "git status --short";
      cs = "codex-switch";
      rb = "nh os switch";
      dsinit = ''nix flake new -t "github:numtide/devshell"'';
    };

    shellAliases = {
      l = "command eza --icons -l --group-directories-first";
      ls = "command eza --icons --group-directories-first";
      ll = "command eza --icons -l --git --header --total-size --time-style=long-iso";
      la = "command eza --icons -l -a --git --header --total-size --time-style=long-iso";
      lt = "command eza --icons --tree --level 3";
      c = "clear";
    };

    functions = {
      y = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };

    interactiveShellInit = ''
      if test "$TERM" = "xterm-ghostty"
        set -gx TERM xterm-256color
      end

      source ${./fish/prompt.fish}
      source ${./fish/theme.fish}
    '';
  };
}
