{
  inputs,
  cell,
}: {
  kodi-wl-hts = inputs.nixpkgs.kodi-wayland.withPackages (exts: [exts.pvr-hts]);
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
