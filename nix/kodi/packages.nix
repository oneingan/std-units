{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib kodi-wayland kodiPackages fetchFromGitHub gettext php zip;

  rel = kodi-wayland.kodiReleaseName;
  
  six = kodiPackages.six.overrideAttrs {
    pythonPath = "lib";
  };

  pytz = kodiPackages.buildKodiAddon rec {
    pname = "pytz";
    namespace = "script.module.pytz";
    version = "2023.3.0";
    src = builtins.fetchzip {
      url = "https://mirrors.kodi.tv/addons/${lib.toLower rel}/${namespace}/${namespace}-${version}+matrix.1.zip";
      sha256 = "sha256-GNUdxFetiuYUOvzOXS8oQwxIyUF7Y2q8lV/UftqVvQs=";
    };
    passthru = {
      pythonPath = "lib";
    };
  };

  tml2ssa = kodiPackages.buildKodiAddon rec {
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
  };

  movistarplus = kodiPackages.buildKodiAddon rec {
    pname = "movistarplus";
    namespace = "plugin.video.movistarplus";
    version = "0.9.4";

    src = fetchFromGitHub {
      owner = "Paco8";
      repo = namespace;
      rev = "v${version}";
      hash = "sha256-L/fuVReoEhp5PoMdp3g2wGU34YwAs54CJ8X3V8q+HpU=";
    };

    propagatedBuildInputs = with kodiPackages; [
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
  }; 
    
in {
  kodi-wl-hts = inputs.nixpkgs.kodi-wayland.withPackages (exts: [
    exts.pvr-hts
    exts.pvr-iptvsimple
    six
    movistarplus
  ]);

  kodi-rpi = let
    kodi = inputs.nixpkgs.kodi.override {
      vdpauSupport = false;
      x11Support = false;
      waylandSupport = true;
      sambaSupport = false;
      rtmpSupport = false;
      joystickSupport = false;
    };
  in
    kodi.withPackages (exts: [
      exts.pvr-iptvsimple
      six
      movistarplus
    ]);
}
