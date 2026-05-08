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
      imports = [
        ./home/fish.nix
      ];

      home.stateVersion = "25.11";

      home.packages = with pkgs; [

        nixd
        nixfmt-rfc-style

        unstable.neovim
        unstable.yazi
        unstable.zellij

        eza
        fastfetch
        fd
        fzf
        zoxide
        ripgrep
        bat
        tree
        zip
        unzip
        btop

        rustup
        tree-sitter

        bubblewrap

        unstable.bun
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
