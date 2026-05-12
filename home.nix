{
  lib,
  userName,
  nixosConfigName,
  ...
}:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.${userName} =
    { ... }:
    {
      imports = [
        ./home/packages.nix
        ./home/git.nix
        ./home/zellij.nix
        ./home/fish.nix
        ./home/fastfetch.nix
      ]
      ++ lib.optionals (nixosConfigName == "nixos-pc") [
        ./home/desktop-packages.nix
        ./home/sway
      ];

      home.stateVersion = "25.11";
    };

  home-manager.users.root =
    { ... }:
    {
      imports = [
        ./home/git.nix
      ];

      home.stateVersion = "25.11";
    };
}
