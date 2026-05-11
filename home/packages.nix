{
  pkgs,
  unstable,
  nvim-config,
  yazi-config,
  codexCliNix,
  codexSwitch,
  aicommits-src,
  ...
}:

let
  aicommits = unstable.callPackage ../pkgs/aicommits.nix {
    inherit aicommits-src;
  };
in
{
  home = {
    packages = with pkgs; [

      # Nix tooling
      unstable.nixd
      unstable.nixfmt
      unstable.nix-init
      unstable.nix-tree

      # Terminal workspace
      unstable.neovim
      unstable.zellij
      unstable.lazygit
      codexCliNix
      codexSwitch
      aicommits

      # CLI utilities
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
      tokei

      # Language servers and formatters
      unstable.lua-language-server
      unstable.stylua
      unstable.fish-lsp
      unstable.tailwindcss-language-server
      unstable.dockerfile-language-server
      unstable.vscode-langservers-extracted
      unstable.vtsls
      unstable.vue-language-server

      # Language runtimes and toolchains
      rustup
      tree-sitter
      unstable.bun
      nodejs
      unstable.clang
      unstable.clang-tools

      # Build and debug tools
      gnumake
      cmake
      pkg-config
      gdb

      # Sandbox helpers
      bubblewrap
    ];

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.bun/bin"
    ];
    sessionVariables = {
      NODE_OPTIONS = "--max-old-space-size=8192";

      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "fd --type f";
    };

    file.".config/nvim" = {
      source = nvim-config;
      recursive = true;
    };

    file.".config/yazi" = {
      source = yazi-config;
      recursive = true;
    };

  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    yazi = {
      enable = true;
      package = unstable.yazi.override {
        _7zz = unstable._7zz-rar;
      };
      extraPackages = with pkgs; [
        file
        resvg
        jq
        unstable.imagemagick
      ];
    };

  };
}
