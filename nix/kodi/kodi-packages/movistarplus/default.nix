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
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "Paco8";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-/JCO+dE/JgKGMBIy7HbnSdVDDSjL2mZ7Te7cgX6Hgzo=";
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
