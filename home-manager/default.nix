{userName, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.${userName} = import ./home.nix;

  home-manager.users.root = {...}: {
    imports = [
      ./home/git.nix
    ];

    home.stateVersion = "25.11";
  };
}
