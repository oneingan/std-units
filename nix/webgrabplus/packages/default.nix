{
  stdenv,
  makeWrapper,
  dotnet-runtime_6,
  buildFHSUserEnv,
  iputils,
}: let
  name = "webgrabplus";
  version = "5.0.1";
  webgrabplus = stdenv.mkDerivation {
    pname = name;
    inherit version;
    src = builtins.fetchurl {
      url = "http://webgrabplus.com/sites/default/files/download/SW/V${version}/WebGrabPlus_V${version}_beta_install.tar.gz";
      sha256 = "sha256:1jw7mnymqap15a45x1rvni4a50iwpw2a3lh3pwrdm1r1a37hpxc2";
    };

    # Work around the "unpacker appears to have produced no
    # directories" error that happens when the archive only have a
    # hidden subdirectory.
    setSourceRoot = "sourceRoot=`pwd`";

    nativeBuildInputs = [makeWrapper];

    buildPhase = false;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/libexec

      cp -vr .wg++/bin.net/* $out/libexec

      makeWrapper ${dotnet-runtime_6}/bin/dotnet $out/bin/webgrabplus \
        --add-flags "$out/libexec/WebGrab+Plus.dll"

      runHook postInstall
    '';
  };
in
  buildFHSUserEnv {
    name = "WebGrab+Plus";
    targetPkgs = pkgs: [
      webgrabplus
      iputils
    ];
    runScript = "webgrabplus";
  }
