{
  inputs,
  cell,
}: {
  tvheadend = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.services.tvheadend;
      pidFile = "${config.users.users.tvheadend.home}/tvheadend.pid";
    in {
      options = {
        services.tvheadend = {
          enable = mkEnableOption (lib.mdDoc "Tvheadend");
          httpPort = mkOption {
            type = types.int;
            default = 9981;
            description = lib.mdDoc "Port to bind HTTP to.";
          };

          htspPort = mkOption {
            type = types.int;
            default = 9982;
            description = lib.mdDoc "Port to bind HTSP to.";
          };

          package = mkOption {
            type = types.package;
            default = pkgs.tvheadend;
            defaultText = literalExpression "pkgs.tvheadend";
            description = lib.mdDoc "The Tvheadend package to use.";
          };

          satipXml = mkOption {
            type = types.str;
            description = lib.mdDoc "URL with the SAT>IP server XML location.";
          };
        };
      };

      config = mkIf cfg.enable {
        users.users.tvheadend = {
          description = "Tvheadend Service user";
          home = "/var/lib/tvheadend";
          createHome = true;
          isSystemUser = true;
          group = "tvheadend";
          extraGroups = ["webgrabplus"];
        };
        users.groups.tvheadend = {};

        systemd.services.tvheadend = {
          description = "Tvheadend TV streaming server";
          wantedBy = ["multi-user.target"];
          after = ["network.target"];

          serviceConfig = {
            Type = "forking";
            PIDFile = pidFile;
            Restart = "always";
            RestartSec = 5;
            User = "tvheadend";
            Group = "video";
            ExecStart = ''
              ${cfg.package}/bin/tvheadend \
              --http_port ${toString cfg.httpPort} \
              --htsp_port ${toString cfg.htspPort} \
              --fork \
              --firstrun \
              --pid ${pidFile} \
              --user tvheadend \
              --group video
            '';
            ExecStop = "${pkgs.coreutils}/bin/rm ${pidFile}";
          };
        };
      };
    };
}
