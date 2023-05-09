{
  inputs,
  cell,
}: {
  generated = inputs.nixpkgs.callPackage ./generated.nix {};
  extensions = cell.packages.extensions;
}
