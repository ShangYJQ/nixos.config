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
      url = "github:ShangYJQ/nvim.config/fd3594d1cd30411876f71231fb675ad74ff9165b";
      flake = false;
    };

    yazi-config = {
      url = "github:ShangYJQ/yazi.config/e38f10569080d5cc9e52b65ec737071a3215d61a";
      flake = false;
    };

    codex-switch = {
      url = "github:ShangYJQ/codex-switch";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nvim-config,
      yazi-config,
      codex-switch,
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

      codexSwitch = codex-switch.packages.${system}.default;
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
              inherit
                unstable
                nvim-config
                yazi-config
                codexSwitch
                ;
            };
          }
        ];
      };
    };
}
