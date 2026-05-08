{
  pkgs,
  unstable,
  nvim-config,
  yazi-config,
  codex-switch,
  ...
}:

{
  home.packages = with pkgs; [

    # Nix tooling
    unstable.nixd
    unstable.nixfmt

    # Terminal workspace
    unstable.neovim
    unstable.yazi
    unstable.zellij
    unstable.lazygit
    codex-switch.packages.${pkgs.stdenv.hostPlatform.system}.default

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
    jdk17
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
}
