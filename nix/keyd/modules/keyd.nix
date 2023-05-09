{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.keyd;
  settingsFormat = pkgs.formats.ini {};
in {
  options = {
    services.keyd = {
      enable = mkEnableOption (lib.mdDoc "keyd, a key remapping daemon");

      package = mkPackageOption pkgs "keyd" {};

      configuration = mkOption {
        type = types.attrsOf (types.lines);

        default = {};

        description = ''
          Attribute set of keyd configuration strings. See https://github.com/rvaiya/keyd/blob/master/docs/keyd.scdoc
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = lib.attrsets.mapAttrs' (name: tcfg: nameValuePair "keyd/${name}.conf" {text = tcfg;}) cfg.configuration;
    };

    hardware.uinput.enable = lib.mkDefault true;

    systemd.services.keyd = {
      description = "Keyd remapping daemon";
      documentation = ["man:keyd(1)"];

      wantedBy = ["multi-user.target"];

      restartTriggers =
        builtins.map (name: config.environment.etc."keyd/${name}.conf".source) (builtins.attrNames cfg.configuration);

      # this is configurable in 2.4.2, later versions seem to remove this option.
      # post-2.4.2 may need to set makeFlags in the derivation:
      #
      #     makeFlags = [ "SOCKET_PATH/run/keyd/keyd.socket" ];
      environment.KEYD_SOCKET = "/run/keyd/keyd.socket";

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/keyd";
        Restart = "always";

        DynamicUser = true;
        SupplementaryGroups = [
          config.users.groups.input.name
          config.users.groups.uinput.name
        ];

        RuntimeDirectory = "keyd";

        # Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = [
          "char-input rw"
          "/dev/uinput rw"
        ];
        ProtectClock = true;
        PrivateNetwork = true;
        ProtectHome = true;
        ProtectHostname = true;
        PrivateUsers = true;
        PrivateMounts = true;
        RestrictNamespaces = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectProc = "noaccess";
        UMask = "0077";
        Nice = "-20";
      };
    };
  };
}
