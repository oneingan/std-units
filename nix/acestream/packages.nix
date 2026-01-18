{
  inputs,
  cell,
}:
let
  inherit (inputs.nixpkgs) callPackage;
in
{
  mpv-acestream = callPackage ./packages/mpv-acestream.nix { };
  acestream-engine = callPackage ./packages/acestream-engine.nix { };
}
