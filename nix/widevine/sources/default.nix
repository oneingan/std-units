{
  inputs,
  cell,
}: {
  generated = inputs.nixpkgs.callPackage ./generated.nix {};
}
