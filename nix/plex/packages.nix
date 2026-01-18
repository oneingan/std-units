{
  inputs,
  cell,
}:
{
  plex = inputs.nixpkgs.plex;
  plex-pass = inputs.nixpkgs.plex.override {
    plexRaw = inputs.nixpkgs.plexRaw.overrideAttrs (old: rec {
      version = "1.32.0.6973-a787c5a8e";
      src = inputs.nixpkgs.fetchurl {
        url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
        sha256 = "sha256-fwMD/vYdwMrUvDB7JmMmVCt47ZtD17zk3bfIuO91dH8=";
      };
    });
  };
}
