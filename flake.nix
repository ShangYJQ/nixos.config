{
  description = "NixOS configuration in pve lxc";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-config = {
      url = "github:ShangYJQ/nvim.config/e76ee094631f25a53606e43e22cf75a91ee9a1ea";
      flake = false;
    };

    yazi-config = {
      url = "github:ShangYJQ/yazi.config/e38f10569080d5cc9e52b65ec737071a3215d61a";
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
      ...
    }:

    let
      system = "x86_64-linux";

      unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit unstable;
        };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit unstable nvim-config yazi-config;
            };
          }
        ];
      };
    };
}
