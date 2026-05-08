{ config, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.root =
    {
      config,
      pkgs,
      unstable,
      nvim-config,
      yazi-config,
      ...
    }:
    {
      home.stateVersion = "25.11";

      home.packages = with pkgs; [

        nixd
        nixfmt-rfc-style

        unstable.neovim
        unstable.yazi

        eza
        fastfetch
        fd
        fzf
        zoxide
        ripgrep
        bat
        tree
        unzip
        btop
        zellij

        rustup
        tree-sitter

        bubblewrap

        bun
        nodejs
        jdk17
        clang
        clang-tools
        gnumake
        cmake
        pkg-config
        gdb
      ];

      home.sessionPath = [
        "$HOME/.cargo/bin"
        "$HOME/.local/bin"
        "$HOME/.bun/bin"
      ];

      home.sessionVariables = {
        JAVA_HOME = "${pkgs.jdk17.home}";

        NODE_OPTIONS = "--max-old-space-size=8192";

        EDITOR = "nvim";
        FZF_DEFAULT_COMMAND = "fd --type f";
      };

      home.file.".config/nvim" = {
        source = nvim-config;
        recursive = true;
      };

      home.file.".config/yazi" = {
        source = yazi-config;
        recursive = true;
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fish = {
        enable = true;

        shellAbbrs = {
          qkgit = "git add .; and aicommits -y; and git push";
          gpl = "git pull";
          gph = "git push";
          g2p = "git pull; and git push";
          ga = "git add .";
          gr = "git restore .";
          gs = "git status --short";
          cs = "codex-switch";
          rebuild = "nixos-rebuild switch --flake /etc/nixos#nixos";
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

          source /etc/nixos/fish/fish_prompt.fish
          source /etc/nixos/fish/fish_frozen_theme.fish
        '';

      };

      programs.zellij = {
        enable = true;
        settings = {
          default_shell = "fish";
          pane_frames = false;
          show_startup_tips = false;

          session_serialization = false;
          # serialize_pane_viewport = false;

          theme = "catppuccin-macchiato";
        };

      };

      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.eza.enable = true;
      programs.bat.enable = true;

      programs.git = {
        enable = true;
        settings = {
          user.name = "ShangYJQ";
          user.email = "421207553@qq.com";
        };
      };
    };
}
