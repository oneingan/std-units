{
  inputs,
  cell,
}:
inputs.nixpkgs.callPackage ./generated.nix { }
