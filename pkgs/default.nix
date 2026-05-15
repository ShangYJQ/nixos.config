{
  pkgs,
  inputs,
  ...
}:
{
  aicommits = pkgs.callPackage ./aicommits.nix {
    inherit (inputs) aicommits-src;
  };
}
