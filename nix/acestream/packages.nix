{
  inputs,
  cell,
}: {
  mpv-acestream = inputs.nixpkgs.callPackage ./packages/mpv-acestream.nix {};
}
