{
  inputs,
  cell,
}: {
  default = inputs.nixpkgs.callPackage ./packages/default.nix {};
}
