{
  inputs,
  cell,
}: {
  kodi-wl-hts = inputs.nixpkgs.kodi-wayland.withPackages (exts: [
    exts.pvr-hts
    exts.pvr-iptvsimple
    (exts.six.overrideAttrs {
      pythonPath = "lib";
    })
    # exts.six
    (let
      inherit (inputs.nixpkgs) lib kodi-wayland fetchzip fetchFromGitHub gettext php zip;
      rel = kodi-wayland.kodiReleaseName;
      pytz = exts.buildKodiAddon rec {
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
      };
      tml2ssa = exts.buildKodiAddon rec {
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
    in exts.buildKodiAddon rec {
      pname = "movistarplus";
      namespace = "plugin.video.movistarplus";
      version = "0.9.4";

      src = inputs.nixpkgs.fetchFromGitHub {
        owner = "Paco8";
        repo = namespace;
        rev = "v${version}";
        hash = "sha256-L/fuVReoEhp5PoMdp3g2wGU34YwAs54CJ8X3V8q+HpU=";
      };

      propagatedBuildInputs = [
        exts.requests
        exts.inputstreamhelper
        pytz
        exts.dateutil
        exts.inputstream-adaptive
        tml2ssa
      ];

      buildInputs = [
        inputs.nixpkgs.zip
      ];
    })
  ]);

  kodi-rpi = let
    kodi = inputs.nixpkgs.kodi.override {
      vdpauSupport = false;
      libva = null;
      x11Support = false;
      waylandSupport = true;
      sambaSupport = false;
      rtmpSupport = false;
      joystickSupport = false;
      lirc = null;
    };
  in
    kodi.withPackages (exts: [exts.pvr-hts]);
}
