{
  lib,
  userName ? "yjq",
  ...
}: {
  imports = [
    ./home/packages.nix
    ./home/git.nix
    ./home/zellij.nix
    ./home/fish.nix
    ./home/fastfetch.nix
  ];

  home = {
    username = lib.mkDefault userName;
    homeDirectory = lib.mkDefault "/home/${userName}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
