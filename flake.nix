{
  description = "NixOS configuration in pve lxc";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs =
    {
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
      system = "x86_64-linux";
      userName = "yjq";
      hostName = "nixos";
      flakePath = "/home/${userName}/nixos";

      unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      codexSwitch = codex-switch.packages.${system}.default;
      codexCliNix = codex-cli-nix.packages.${system}.default;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit
            unstable
            userName
            hostName
            flakePath
            ;
        };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit
                unstable
                nvim-config
                yazi-config
                codexCliNix
                codexSwitch
                aicommits-src
                userName
                ;
            };
          }
        ];
      };
    };
}
