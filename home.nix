{ config, pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "11.0";
    platformToolsVersion = "36.0.0";

    buildToolsVersions = [
      "35.0.0"
      "36.0.0"
    ];

    platformVersions = [
      "35"
      "36"
    ];

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
        androidSdk
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

        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";

        ANDROID_NDK_HOME = "${androidSdk}/libexec/android-sdk/ndk/26.3.11579264";
        NDK_HOME = "${androidSdk}/libexec/android-sdk/ndk/26.3.11579264";

        NODE_OPTIONS = "--max-old-space-size=8192";
      };

      home.file.".config/nvim" = {
        source = builtins.fetchGit {
          url = "https://github.com/ShangYJQ/nvim.config.git";
          rev = "e76ee094631f25a53606e43e22cf75a91ee9a1ea";
        };
        recursive = true;
      };

      home.file.".config/yazi" = {
        source = builtins.fetchGit {
          url = "https://github.com/ShangYJQ/yazi.config.git";
          rev = "e38f10569080d5cc9e52b65ec737071a3215d61a";
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
          show_startup_tips = false;

          session_serialization = false;
          # serialize_pane_viewport = false;

          theme = "catppuccin-mocha";
        };

        themes = {
          catppuccin-mocha = ''
            themes {
              catppuccin-mocha {
                fg "#cdd6f4"
                bg "#1e1e2e"
                black "#45475a"
                red "#f38ba8"
                green "#a6e3a1"
                yellow "#f9e2af"
                blue "#89b4fa"
                magenta "#f5c2e7"
                cyan "#94e2d5"
                white "#bac2de"
                orange "#fab387"
              }
            }
          '';
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
