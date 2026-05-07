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

        rustup
        tree-sitter

        clang
        clang-tools
        gnumake
        cmake
        pkg-config
        gdb
      ];

      home.file.".config/nvim" = {
        source = builtins.fetchGit {
          url = "https://github.com/ShangYJQ/nvim.config.git";
          rev = "db28eca379c3b9772b52b1b205aa984c42a5a2fb";
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
