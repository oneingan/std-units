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
    hash = "sha256-YsbTyX0YVQ+1MOJNZs5Ez02rHbgF4VuaCmPDIYz+diw=";
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
