{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  pkgs = nixpkgs;
in {
  tvheadend = pkgs.callPackage ./tvheadend.nix {};
}
