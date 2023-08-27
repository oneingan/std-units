{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "mpv-acestream";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Digitalone1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+jsNGtkvzjckTQLIuIgCj4E1QYVr5TKn0ju2mSj8cVA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/mpv/scripts scripts/mpv-acestream.lua
    runHook postInstall
  '';

  passthru.scriptName = "mpv-acestream.lua";

  meta = with lib; {
    description = " Small Lua script that adds AceStream protocol handler to mpv player";
    homepage = "https://github.com/Digitalone1/mpv-acestream";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ oneingan ];
  };
}
