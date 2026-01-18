{
  stdenv,
  lib,
  fetchFromGitHub,
  runtimeShell,
  python3,
}:
let
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v" + version;
    hash = "sha256-QWr+xog16MmybhQlEWbskYa/dypb9Ld54MOdobTbyMo=";
  };

  pypkgs = python3.pkgs;

  appMap = pypkgs.buildPythonApplication rec {
    pname = "keyd-application-mapper";
    inherit version src;
    format = "other";

    postPatch = ''
      substituteInPlace scripts/${pname} \
        --replace /bin/sh ${runtimeShell}
    '';

    propagatedBuildInputs = with pypkgs; [ xlib ];

    dontBuild = true;

    installPhase = ''
      install -Dm555 -t $out/bin scripts/${pname}
    '';

    meta.mainProgram = pname;
  };
in
stdenv.mkDerivation rec {
  pname = "keyd";
  inherit version src;

  postPatch = ''
    substituteInPlace Makefile \
      --replace "\$(shell git describe --no-match --always --abbrev=7 --dirty)" "${version}" \
      --replace PREFIX=/usr PREFIX= \
      --replace SOCKET_PATH=/var/run/keyd.socket SOCKET_PATH=/run/keyd/keyd.socket
  '';

  buildFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    ln -sf ${lib.getExe appMap} $out/bin/${appMap.pname}
    rm -rf $out/etc
  '';

  meta = with lib; {
    description = "A key remapping daemon for linux.";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
