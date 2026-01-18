{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook,
  makeShellWrapper,
  squashfsTools,
}:
let
  pname = "plex-desktop";
  version = "1.83.1";
  snapId = "qc6MFRM433ZhI1XjVzErdHivhSOhlpf0";
  snapRev = "54";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/${snapId}_${snapRev}.snap";
    hash = "sha256-cggDlhVqxu2xk/gWyZCemtSa4DMSOAg6mana6SIkcAI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    makeShellWrapper
    squashfsTools
  ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
    cd squashfs-root
    if ! grep -q 'grade: stable' meta/snap.yaml; then
      # Unfortunately this check is not reliable: At the moment (2018-07-26) the
      # latest version in the "edge" channel is also marked as stable.
      echo "The snap package is marked as unstable:"
      grep 'grade: ' meta/snap.yaml
      echo "You probably chose the wrong revision."
      exit 1
    fi
    if ! grep -q '${version}' meta/snap.yaml; then
      echo "Package version differs from version found in snap metadata:"
      grep 'version: ' meta/snap.yaml
      echo "While the nix package specifies: ${version}."
      echo "You probably chose the wrong revision or forgot to update the nix version."
      exit 1
    fi
    runHook postUnpack
  '';

  # Prevent double wrapping
  dontWrapGApps = true;

  meta = with lib; {
    description = "Clientless remote desktop gateway";
    homepage = "https://guacamole.incubator.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ tomberek ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
