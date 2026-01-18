{
  inputs,
  cell,
}:
{
  plex-desktop = inputs.nixpkgs.callPackage ./packages/default.nix { };
}
