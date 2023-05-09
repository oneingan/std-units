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
  latest = pkgs.tvheadend.overrideAttrs (old: {
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
  movistar-epg = pkgs.writeShellApplication {
    name = "tv_grab_EpgGratis";
    text = builtins.readFile ./tv_grab_EpgGratis;
    runtimeInputs = [
      gzip
      wget
    ];
    # checkPhase = false;
  };
  webgrabplus = let
    name = "webgrabplus";
    version = "3.3";
  in
    stdenv.mkDerivation {
      pname = name;
      inherit version;
      src = builtins.fetchurl {
        url = "http://webgrabplus.com/sites/default/files/download/SW/V${version}.0/WebGrabPlus_V${version}_install.tar.gz";
        sha256 = "1gdzm94357pfk81myff3vwlgch0j36d4my050avyq10zcyn9z5gk";
      };

      # Work around the "unpacker appears to have produced no
      # directories" case that happens when the archive only have a
      # hidden subdirectory.
      setSourceRoot = "sourceRoot=`pwd`";

      nativeBuildInputs = [makeWrapper];

      buildPhase = false;
      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/libexec
        mkdir -p $out/share/${name}/doc/config

        cp -vr .wg++/bin/* $out/libexec

        makeWrapper ${mono}/bin/mono $out/bin/wg++ \
        --add-flags "$out/libexec/WebGrab+Plus.exe"

        cp -vr .wg++/WebGrab++.config.example.xml $out/share/${name}/doc/config/.
        cp -vr .wg++/rex/rex.config.example.xml $out/share/${name}/doc/config/.
        cp -vr .wg++/mdb/mdb.config.example.xml $out/share/${name}/doc/config/.
      '';
    };
}
