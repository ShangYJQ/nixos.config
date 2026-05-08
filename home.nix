{ config, pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "11.0";
    platformToolsVersion = "35.0.2";

    buildToolsVersions = [ "35.0.0" ];
    platformVersions = [ "35" ];

    includeEmulator = false;
    includeSystemImages = false;
    includeSources = false;

    # Tauri Android 需要 NDK
    includeNDK = true;
    ndkVersions = [ "26.3.11579264" ];

    includeCmake = true;
    cmakeVersions = [ "3.22.1" ];
  };

  androidSdk = androidComposition.androidsdk;
in

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
        codex
        jdk17
        androidSdk
        clang
        clang-tools
        gnumake
        cmake
        pkg-config
        gdb
      ];

      home.sessionVariables = {
        JAVA_HOME = "${pkgs.jdk17.home}";

        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";

        ANDROID_NDK_HOME = "${androidSdk}/libexec/android-sdk/ndk/26.3.11579264";
        NDK_HOME = "${androidSdk}/libexec/android-sdk/ndk/26.3.11579264";
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
