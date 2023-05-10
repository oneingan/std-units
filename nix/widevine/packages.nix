{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) stdenv patchelf gcc glib nspr nss unzip;
  l = nixpkgs.lib // builtins;

  mkrpath = p: "${l.makeSearchPathOutput "lib" "lib64" p}:${l.makeLibraryPath p}";
  inherit (cell.sources.generated.widevine) src pname version;
in {
  widevine = stdenv.mkDerivation {
    inherit src pname version;

    unpackCmd = "unzip -d ./src $curSrc";

    nativeBuildInputs = [unzip];

    PATCH_RPATH = mkrpath [gcc.cc glib nspr nss];

    patchPhase = ''
      patchelf --set-rpath "$PATCH_RPATH" libwidevinecdm.so
    '';

    installPhase = ''
      install -vD libwidevinecdm.so \
        "$out/lib/libwidevinecdm.so"
    '';

    meta.platforms = ["x86_64-linux"];
  };
}
