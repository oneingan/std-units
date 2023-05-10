{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit
    (inputs.nixpkgs)
    libva
    libdvbcsa
    libopus
    libvpx
    x264
    x265
    stdenv
    gzip
    wget
    mono
    makeWrapper
    ;
  pkgs = nixpkgs;
in {
  tvheadend = pkgs.tvheadend.overrideAttrs (old: {
    inherit (cell.sources.generated.tvheadend) pname src;
    version = "unstable-${cell.sources.generated.tvheadend.date}";
    patches = [];
    buildInputs =
      old.buildInputs
      ++ [
        libva
        libdvbcsa
        libopus
        libvpx
        x264
        x265
      ];
    configureFlags = old.configureFlags ++ ["--disable-libopus_static"];
  });
}
