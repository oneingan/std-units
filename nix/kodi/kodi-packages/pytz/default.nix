{
  buildKodiAddon,
  lib,
  fetchzip,
  rel,
}:

buildKodiAddon rec {
  pname = "pytz";
  namespace = "script.module.pytz";
  version = "2023.3.0";
  src = fetchzip {
    url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}+matrix.1.zip";
    sha256 = "sha256-GNUdxFetiuYUOvzOXS8oQwxIyUF7Y2q8lV/UftqVvQs=";
  };
  passthru = {
    pythonPath = "lib";
  };
}
