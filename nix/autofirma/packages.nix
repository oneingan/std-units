{
  inputs,
  cell,
}:
{
  autofirma = inputs.nixpkgs.callPackage ./packages/autofirma.nix { };
}
