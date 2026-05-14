{
  lib,
  userName ? "yjq",
  nixosConfigName ? "nixos-pc",
  walker,
  ...
}: {
  imports =
    [
      ./home/packages.nix
      ./home/git.nix
      ./home/zellij.nix
      ./home/fish.nix
      ./home/fastfetch.nix
    ]
    ++ lib.optionals (nixosConfigName == "nixos-pc") [
      walker.homeManagerModules.default
      ./home/desktop-packages.nix
      ./home/sway
    ];

  home = {
    username = lib.mkDefault userName;
    homeDirectory = lib.mkDefault "/home/${userName}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
