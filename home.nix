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
      ...
    }:
    {
      home.stateVersion = "25.05";

      home.packages = with pkgs; [

        nixd
        nixfmt-rfc-style

        unstable.neovim
        eza
        fastfetch
        fd
        fzf
        zoxide
        yazi
        ripgrep
        bat
        tree
        unzip
        btop
        zellij

        rustup
        tree-sitter

        bun
        nodejs
        jdk17
        androidsdk
        clang
        clang-tools
        gnumake
        cmake
        pkg-config
        gdb
      ];

      home.sessionVariables = {
        JAVA_HOME = "${pkgs.jdk17.home}";
      };

      home.file.".config/nvim" = {
        source = builtins.fetchGit {
          url = "https://github.com/ShangYJQ/nvim.config.git";
          rev = "e76ee094631f25a53606e43e22cf75a91ee9a1ea";
        };
        recursive = true;
      };

      programs.fish = {
        enable = true;

        interactiveShellInit = ''
          source /etc/nixos/fish/config.fish
          source /etc/nixos/fish/fish_prompt.fish
          source /etc/nixos/fish/fish_frozen_theme.fish
        '';
      };

      programs.zellij = {
        enable = true;
        settings = {
          default_shell = "fish";
          pane_frames = false;
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
        userName = "ShangYJQ";
        userEmail = "421207553@qq.com";
      };
    };
}
