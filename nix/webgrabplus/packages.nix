{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit
    (inputs.nixpkgs)
    gzip
    wget
    callPackage
    ;
  pkgs = nixpkgs;
in {
  movistar-epg = pkgs.writeShellApplication {
    name = "tv_grab_EpgGratis";
    text = builtins.readFile ./tv_grab_EpgGratis;
    runtimeInputs = [
      gzip
      wget
    ];
    # checkPhase = false;
  };
  webgrabplus = callPackage ./packages/default.nix {};
}
