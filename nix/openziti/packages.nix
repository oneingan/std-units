{
  inputs,
  cell,
}: {
  openziti = inputs.nixpkgs.callPackage ./packages/default.nix {};
}
