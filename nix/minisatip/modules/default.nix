{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.minisatip;
in
{
  options = {
    services.minisatip = {
      enable = mkEnableOption (lib.mdDoc "SAT>IP server");

      package = mkPackageOption pkgs "minisatip" { };

      rtspPort = mkOption {
        type = types.port;
        default = 8554;
        description = lib.mdDoc ''
          Port for listening for rtsp requests.
        '';
      };

      httpPort = mkOption {
        type = types.port;
        default = 8080;
        description = lib.mdDoc ''
          Port for listening on http.
        '';
      };

      extraParams = mkOption {
        type =
          with types;
          attrsOf (oneOf [
            str
            int
            bool
            (listOf str)
          ]);
        default = {
          document-root = "${cfg.package}/share/minisatip/html";
        };
        description = lib.mdDoc ''
          Extra parameters passed to the minisatip instance.
          Run `minisatip --help` to see more options.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open httpPort and
          rtspPort in the firewall as well as any optionally
          enabled minisatip receiver ports.
        '';
      };
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.minisatip = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        CacheDirectory = "minisatip";
        ExecStart = "${cfg.package}/bin/minisatip -f --rtsp-port ${toString cfg.rtspPort} --http-port ${toString cfg.httpPort} ${
          lib.cli.toGNUCommandLineShell { } cfg.extraParams
        }";
        Restart = "always";

        # Hardening
        AmbientCapabilities = mkIf (cfg.rtspPort < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = mkIf (cfg.rtspPort < 1024) [ "CAP_NET_BIND_SERVICE" ];
        PrivateUsers = cfg.rtspPort >= 1024;
        DynamicUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
      cfg.httpPort # default: 8080
      cfg.rtspPort # default: 8554
    ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [
      6500
      6501
      6502
      6503
      6504
      6505
      6506
      6507
      6508
      6509
      6510
      6511
      6512
      6513
      6514
      6515
    ];
  };
}
