{
  buildKodiAddon,
  fetchFromGitHub,
  requests,
  inputstreamhelper,
  pytz,
  dateutil,
  inputstream-adaptive,
  tml2ssa,
  zip
}: buildKodiAddon rec {
  pname = "movistarplus";
  namespace = "plugin.video.movistarplus";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Paco8";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-NDqB9M+dcF6/2FGPEkeHMdfr/Z+DAxHcIBPDuGo3b0g=";
  };

  propagatedBuildInputs = [
    requests
    inputstreamhelper
    pytz
    dateutil
    inputstream-adaptive
    tml2ssa
  ];

  buildInputs = [
    zip
  ];
}
