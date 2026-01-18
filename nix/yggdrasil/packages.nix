{
  inputs,
  cell,
}:
{
  yggdrasil = inputs.nixpkgs.callPackage ./packages/default.nix { };
}
