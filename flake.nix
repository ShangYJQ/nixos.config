{
  description = "Nix terminal tools and nixos-lxc";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    codex-switch = {
      url = "github:ShangYJQ/codex-switch";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nvim-config = {
      url = "github:ShangYJQ/nvim.config";
      flake = false;
    };

    yazi-config = {
      url = "github:ShangYJQ/yazi.config";
      flake = false;
    };

    aicommits-src = {
      url = "github:Nutlope/aicommits";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nvim-config,
      yazi-config,
      codex-cli-nix,
      codex-switch,
      aicommits-src,
      ...
    }:
    let
      userName = "yjq";
      flakePath = "/home/${userName}/nixos";

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkUnstable =
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

      mkSpecialArgs =
        {
          system,
          hostName ? "arch",
          nixosConfigName ? null,
        }:
        let
          unstable = mkUnstable system;
        in
        {
          inherit
            inputs
            unstable
            nvim-config
            yazi-config
            aicommits-src
            userName
            hostName
            nixosConfigName
            flakePath
            ;

          codexCliNix = codex-cli-nix.packages.${system}.default;
          codexSwitch = codex-switch.packages.${system}.default;
        };

      mkHome =
        {
          system ? "x86_64-linux",
          hostName ? "arch",
          nixosConfigName ? null,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          extraSpecialArgs = mkSpecialArgs {
            inherit system hostName nixosConfigName;
          };
          modules = [
            ./home-manager/home.nix
          ];
        };
    in
    {
      packages = forAllSystems (
        system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit inputs;
        }
      );

      nixosConfigurations.nixos-lxc =
        let
          system = "x86_64-linux";
          specialArgs = mkSpecialArgs {
            inherit system;
            hostName = "nixos";
            nixosConfigName = "nixos-lxc";
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
            }
            ./nixos/configuration.nix
            ./hosts/nixos-lxc
          ];
        };

      homeConfigurations.${userName} = mkHome { };
    };
}
