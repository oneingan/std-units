{
  lib,
  stdenv,
  fetchFromGitHub,
  libdvbcsa,
}:
stdenv.mkDerivation rec {
  pname = "minisatip";
  version = "1.2.102";

  src = fetchFromGitHub {
    owner = "catalinii";
    repo = "minisatip";
    rev = "v${version}";
    hash = "sha256-evhrt3ZwRvUsvziSiDEtKa8JdgXlrFSC9CSXoARQP5I=";
  };

  buildInputs = [libdvbcsa];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/minisatip
    chmod +x minisatip
    cp -v minisatip $out/bin/
    cp -rv html $out/share/minisatip
  '';

  meta = with lib; {
    description = "Minisatip is an SATIP server for linux using local DVB-S2, DVB-C, DVB-T or ATSC cards";
    homepage = "https://github.com/catalinii/minisatip";
    license = with licenses; [];
    maintainers = with maintainers; [];
  };
}
