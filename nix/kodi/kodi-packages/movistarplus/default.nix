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
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "Paco8";
    repo = namespace;
    rev = "v${version}";
    hash = "sha256-t80u2wCgHe9oDe7qxtZ6GVt+ybnYkre3o3UJxQNVJf8=";
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
