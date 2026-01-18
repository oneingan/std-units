{
  buildKodiAddon,
  fetchFromGitHub,
  gettext,
  php,
  zip,
}:
buildKodiAddon rec {
  pname = "ttml2ssa";
  namespace = "script.module.ttml2ssa";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "Paco8";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QPsFHB328ErwgZMyPt0JSBZkelJHSZmGYOu3BlCiiEQ=";
  };

  buildPhase = ''
    cd kodi
    make install
  '';

  postPatch = ''
    patchShebangs kodi/translations/create_pot.php
  '';

  buildInputs = [
    gettext
    php
    zip
  ];

  passthru = {
    pythonPath = "resources/lib";
  };
}
