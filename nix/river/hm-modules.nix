{
  inputs,
  cell,
}: {
  river = {
    config,
    lib,
    pkgs,
    ...
  }:
    with lib; let
      cfg = config.wayland.windowManager.river;

      configFile = pkgs.writeShellScript "river.conf" (concatStringsSep "\n"
        ((
            if cfg.config != null
            then with cfg.config; []
            else []
          )
          ++ (optional cfg.systemdIntegration ''
              ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP; systemctl --user start river-session.target'')
          ++ [cfg.extraConfig]));
    in {
      options.wayland.windowManager.river = {
        enable = mkEnableOption "river wayland compositor";

        package = mkOption {
          type = with types; nullOr package;
          default = pkgs.river;
          defaultText = literalExpression "${pkgs.river}";
        };

        systemdIntegration = mkOption {
          type = types.bool;
          default = pkgs.stdenv.isLinux;
          example = false;
        };

        config = mkOption {
          type = types.nullOr types.lines;
          default = null;
          description = "River configuration options.";
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = "Extra configuration lines to add to ~/.config/river/init.";
        };

        extraSessionCommands = mkOption {
          type = types.lines;
          default = "";
        };
      };
      config = mkIf cfg.enable {
        home.packages = [
          cfg.package
          pkgs.foot
          pkgs.rofi-wayland
        ];

        xdg.configFile."river/init" = {
          # let
          # riverPackage = if cfg.package == null then pkgs.river else cfg.package;
          # in {
          source = configFile;
          executable = true;
          #  onChange = ''
          #     swaySocket="''${XDG_RUNTIME_DIR:-/run/user/$UID}/sway-ipc.$UID.$(${pkgs.procps}/bin/pgrep --uid $UID -x sway || true).sock"
          #     if [ -S "$swaySocket" ]; then
          #       ${riverPackage}/bin/swaymsg -s $swaySocket reload
          #     fi
          #   '';
        };

        systemd.user.targets.river-session = mkIf cfg.systemdIntegration {
          Unit = {
            Description = "river compositor session";
            Documentation = ["man:systemd.special(7)"];
            BindsTo = ["graphical-session.target"];
            Wants = ["graphical-session-pre.target"];
            After = ["graphical-session-pre.target"];
          };
        };
      };
    };
}
