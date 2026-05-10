{ userName, ... }:

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
