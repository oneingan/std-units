{
  inputs,
  cell,
}:
let
  inherit (inputs) nixpkgs;
  pkgs = nixpkgs;
in
{
  keyd-unstable = (pkgs.callPackage ./packages/unstable.nix { }).overrideAttrs (old: {
    inherit (cell.sources.generated.keyd) pname src;
    version = "unstable-${cell.sources.generated.keyd.date}";
    makeFlags = [ "SOCKET_PATH=/run/keyd/keyd.socket" ];
  });
}
