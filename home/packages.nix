{
  pkgs,
  unstable,
  nvim-config,
  yazi-config,
  ...
}:

{
  home.packages = with pkgs; [

    nixd
    nixfmt-rfc-style

    unstable.neovim
    unstable.yazi
    unstable.zellij
    unstable.lazygit

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
