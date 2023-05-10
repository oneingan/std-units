{
  inputs,
  cell,
}: {
  minisatip = inputs.nixpkgs.callPackage ./packages/default.nix {};
}
