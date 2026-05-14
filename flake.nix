{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant = {
      url = "github:abenz1267/elephant";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    daeuniverse.url = "github:daeuniverse/flake.nix";

    nvim-config = {
      url = "github:ShangYJQ/nvim.config";
      flake = false;
    };

    yazi-config = {
      url = "github:ShangYJQ/yazi.config";
      flake = false;
    };

    codex-switch = {
      url = "github:ShangYJQ/codex-switch";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    aicommits-src = {
      url = "github:Nutlope/aicommits";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-wayland,
    home-manager,
    walker,
    daeuniverse,
    nvim-config,
    yazi-config,
    codex-cli-nix,
    codex-switch,
    aicommits-src,
    ...
  }: let
    userName = "yjq";
    flakePath = "/home/${userName}/nixos";

    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    overlays = import ./overlays {inherit inputs;};

    mkUnstable = {
      nixosConfigName,
      system,
    }:
      import nixpkgs-unstable {
        inherit system;
        overlays = nixpkgs.lib.optionals (nixosConfigName == "nixos-pc") [
          nixpkgs-wayland.overlays.default
        ];
        config.allowUnfree = true;
      };

    mkPkgs = {system}:
      import nixpkgs {
        inherit system;
        overlays = [
          overlays.additions
          overlays.modifications
          overlays.unstable-packages
        ];
        config.allowUnfree = true;
      };

    mkSpecialArgs = {
      nixosConfigName,
      hostName,
      system,
    }: let
      unstable = mkUnstable {inherit nixosConfigName system;};
    in {
      inherit
        inputs
        unstable
        walker
        nvim-config
        yazi-config
        aicommits-src
        userName
        nixosConfigName
        hostName
        flakePath
        ;

      codexSwitch = codex-switch.packages.${system}.default;
      codexCliNix = codex-cli-nix.packages.${system}.default;
    };

    mkHost = {
      nixosConfigName,
      hostName,
      system,
      modules,
    }: let
      specialArgs = mkSpecialArgs {
        inherit nixosConfigName hostName system;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;

        modules =
          modules
          ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
      };

    mkHome = {
      nixosConfigName,
      hostName,
      system,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs {inherit system;};
        extraSpecialArgs = mkSpecialArgs {
          inherit nixosConfigName hostName system;
        };
        modules = [
          ./home-manager/home.nix
        ];
      };
  in {
    packages = forAllSystems (
      system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit inputs;
        }
    );

    formatter = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.writeShellApplication {
          name = "nix-config-format";
          runtimeInputs = [pkgs.alejandra];
          text = ''
            if [ "$#" -eq 0 ] || { [ "$#" -eq 1 ] && [ "$1" = "." ]; }; then
              set -- flake.nix nixos home-manager hosts pkgs overlays modules
            fi

            exec alejandra "$@"
          '';
        }
    );

    inherit overlays;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      nixos-lxc = mkHost {
        nixosConfigName = "nixos-lxc";
        hostName = "nixos";
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          ./hosts/nixos-lxc
        ];
      };

      nixos-utm = mkHost {
        nixosConfigName = "nixos-utm";
        hostName = "nixos";
        system = "aarch64-linux";
        modules = [
          ./nixos/configuration.nix
          ./hosts/nixos-utm
        ];
      };

      nixos-pc = mkHost {
        nixosConfigName = "nixos-pc";
        hostName = "nixos";
        system = "x86_64-linux";
        modules = [
          daeuniverse.nixosModules.daed
          ./nixos/configuration.nix
          ./hosts/nixos-pc
        ];
      };
    };

    homeConfigurations = {
      "${userName}@nixos-lxc" = mkHome {
        nixosConfigName = "nixos-lxc";
        hostName = "nixos";
        system = "x86_64-linux";
      };

      "${userName}@nixos-utm" = mkHome {
        nixosConfigName = "nixos-utm";
        hostName = "nixos";
        system = "aarch64-linux";
      };

      "${userName}@nixos-pc" = mkHome {
        nixosConfigName = "nixos-pc";
        hostName = "nixos";
        system = "x86_64-linux";
      };
    };
  };
}
