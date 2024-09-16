{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) callPackage kodi-wayland;

  myKodiPackages = callPackage ./kodi-packages { };
    
in {
  kodi-wl-hts = kodi-wayland.withPackages (exts: [
    exts.pvr-hts
    exts.pvr-iptvsimple
    (exts.six.overrideAttrs { pythonPath = "lib"; })
    myKodiPackages.movistarplus
  ]);

  kodi-rpi = let
    kodi = inputs.nixpkgs.kodi-wayland.override {
      # vdpauSupport = false;
      # x11Support = false;
      # waylandSupport = true;
      # sambaSupport = false;
      # rtmpSupport = false;
      # joystickSupport = false;
    };
  in
    kodi.withPackages (exts: [
      exts.pvr-iptvsimple
      (exts.six.overrideAttrs { pythonPath = "lib"; })
      (exts.toKodiAddon myKodiPackages.movistarplus)
      (exts.toKodiAddon myKodiPackages.tml2ssa)
      (exts.toKodiAddon myKodiPackages.pytz)
      exts.dateutil
      exts.requests
      exts.inputstreamhelper
    ]);
}
