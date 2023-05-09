{
  inputs,
  cell,
}: {
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.urbit;

  idOpts = {name, ...}: {
    options = {
      name = mkOption {
        type = types.str;
        default = "";
        example = "zod";
        description = "Urbit ID name";
      };

      httpPort = mkOption {
        type = types.port;
        default = "";
        example = "8080";
        description = "Urbit Landscape port";
      };

      amesPort = mkOption {
        type = types.port;
        default = "";
        example = "52000";
        description = "Urbit Ames UDP port";
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0w5hKKG.8LwHw.6OQ4j.iDqRv.HpM5L.1qoKF.pCDXV.hP21K.oqL-h.ju76L.1Cbq~.GPt4q.kyYyL.iYDzw.6lhNg.p-2BZ.MFAtj.68g8w.0t3Cd.0JdQ1";
        description = "Urbit networking key";
      };
    };
  };
in {
  options = {
    services.urbit = {
      ids = mkOption {
        default = {};
        type = with types; attrsOf (submodule idOpts);
        description = "Attributes set of Urbit IDs to be spawned";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.ids != {}) {
      systemd.services = let
        services = concatLists servicesLists;
        servicesLists = mapAttrsToList idToServices cfg.ids;
        idToServices = id: data: let
          mountPoint = replaceStrings ["-"] ["\\x2d"] id;

          keyFile = pkgs.writeText "network.key" "${data.key}";

          createPierCmd =
            #"${pkgs.urbit}/bin/urbit -c $TMPDIR/pier -A ${pkgs.urbit-os.arvo} -B ${pkgs.urbit-os.solid.build} -x -t "
            "${cell.packages.urbit}/bin/urbit -c $TMPDIR/pier -A ${cell.packages.urbit-os.arvo} -x -t "
            + (
              if !isNull data.key
              then "-w ${id} -k ${keyFile}"
              else "-F ${id}"
            );

          urbitService = {
            description = "Launch Urbit for ${id}";
            after = ["network.target"];
            wantedBy = ["multi-user.target"];
            path = [cell.packages.urbit];
            requisite = ["home-${mountPoint}-pier.mount"];
            wants = ["home-${mountPoint}-pier.mount" "acme-${id}.service"];
            serviceConfig = {
              Type = "simple";
              User = "${id}";
              Group = "${id}";
              ExecStart = "${cell.packages.urbit}/bin/urbit --http-port ${toString data.httpPort} --ames-port ${toString data.amesPort} -t /home/${id}/pier --loom 32";
              Restart = "on-failure";
            };
          };

          pierCreateService = {
            wantedBy = ["urbit-vol-init-${id}.service"];
            before = ["urbit-vol-init-${id}.service"];
            unitConfig.ConditionPathExists = "!/home/${id}/${id}.tar.gz";
            path = [pkgs.gzip];
            script = ''
              TMPDIR=$(mktemp -d)
                            ${createPierCmd}
                            sleep 5
                            ${pkgs.gnutar}/bin/tar -Scvzf /home/${id}/${id}.tar.gz -C $TMPDIR/pier/ .
              rm -rf $TMPDIR
            '';
            serviceConfig = {Type = "oneshot";};
          };

          volInitService = {
            wantedBy = ["urbit-${id}.service"];
            before = ["urbit-${id}.service" "home-${mountPoint}-pier.mount"];
            unitConfig.ConditionPathExists = "!/home/${id}/image.btrfs";
            path = [pkgs.gzip];
            script = ''
              truncate --size=5G /home/${id}/image.btrfs
              ${pkgs.btrfs-progs}/bin/mkfs.btrfs /home/${id}/image.btrfs
              TMPMNT=$(mktemp -d)
              ${pkgs.utillinux}/bin/mount -o loop /home/${id}/image.btrfs $TMPMNT
                            ${pkgs.gnutar}/bin/tar xvfz /home/${id}/${id}.tar.gz -C $TMPMNT
              chown -R ${id}:${id} $TMPMNT
                            sync
              ${pkgs.utillinux}/bin/umount $TMPMNT
              rm -rf $TMPMNT
            '';
            serviceConfig = {Type = "oneshot";};
          };
        in [
          {
            name = "urbit-${id}";
            value = urbitService;
          }
          {
            name = "urbit-vol-init-${id}";
            value = volInitService;
          }
          {
            name = "urbit-pier-create-${id}";
            value = pierCreateService;
          }
        ];
        servicesAttr = listToAttrs services;
      in
        servicesAttr;

      systemd.mounts = map (id: {
        what = "/home/${id}/image.btrfs";
        where = "/home/${id}/pier";
        type = "btrfs";
        options = "loop";
        #bindsTo = [ "urbit-${id}.service" ];
        before = ["urbit-${id}.service"];
      }) (attrNames cfg.ids);

      users.users = builtins.mapAttrs (name: data: {
        isNormalUser = true;
        group = data.name;
        description = "${data.name} user";
        home = "/home/${data.name}";
      }) (cfg.ids);

      users.groups = mapAttrs (name: data: {}) (cfg.ids);

      # security.acme.acceptTerms = true;
      # security.acme.email = "acme@urbit.es";
      # security.acme.certs = let
      #   certsAttr = map (id: {
      #     name = id;
      #     value = rec {
      #       domain = "${id}.urbit.es";
      #       webroot = "/var/lib/acme/acme-challenges";
      #       postRun = ''
      #         mkdir -p /var/lib/acme/
      #         cp -p /var/lib/acme/${id}/full.pem /var/lib/acme/${domain}.pem
      #         chown haproxy /var/lib/acme/${domain}.pem
      #         systemctl reload-or-restart haproxy.service
      #       '';
      #     };
      #   }) (attrNames cfg.ids);
      # in listToAttrs certsAttr;
      #
      # services.haproxy.config = let
      #   frontendBaseConfig = ''
      #     frontend https-in
      #       bind *:443 ssl crt /var/lib/acme/
      #   '';
      #   frontendConfig = concatMapStrings (data: ''
      #     acl ${data.name} ssl_fc_sni -i ${data.name}.urbit.es
      #     use_backend ${data.name} if ${data.name}
      #   '') (attrValues cfg.ids);
      #
      #   backendConfig = concatMapStrings (data: ''
      #     backend ${data.name}
      #       server node1 127.0.0.1:${toString data.httpPort}
      #   '') (attrValues cfg.ids);
      #
      # in frontendBaseConfig + frontendConfig + backendConfig;

      networking.firewall = {
        allowedUDPPorts = map (data: data.amesPort) (attrValues cfg.ids);
      };
    })
  ];
}
