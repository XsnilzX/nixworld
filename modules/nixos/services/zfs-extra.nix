_: {
  flake.nixosModules.services-zfs-extra = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.zfsExtra;

    mkKeyService = keyLoad: {
      name = "zfs-load-key-${keyLoad.name}";
      value = {
        description = "Load ZFS encryption key for ${keyLoad.pool}";
        after = ["zfs-import.target"];
        before = ["zfs-mount.service"];
        wantedBy = ["zfs-mount.service"];

        unitConfig = {
          ConditionPathExists = keyLoad.keyFile;
          DefaultDependencies = false;
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStartPre = "${pkgs.coreutils}/bin/chmod 400 ${keyLoad.keyFile}";
          ExecStart = "/run/current-system/sw/bin/zfs load-key ${keyLoad.pool}";
          Restart = "no";
          TimeoutSec = 30;
        };
      };
    };
  in {
    options.services.zfsExtra = {
      hostId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Host ID used by ZFS imports.";
      };

      extraPools = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional ZFS pools to import.";
      };

      arcMax = lib.mkOption {
        type = lib.types.int;
        default = 6442450944;
        description = "Maximum ARC size in bytes.";
      };

      arcMin = lib.mkOption {
        type = lib.types.int;
        default = 1073741824;
        description = "Minimum ARC size in bytes.";
      };

      keyLoads = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Suffix for the generated systemd unit name.";
            };

            pool = lib.mkOption {
              type = lib.types.str;
              description = "ZFS pool or dataset name passed to zfs load-key.";
            };

            keyFile = lib.mkOption {
              type = lib.types.str;
              description = "Path to the key file for the pool.";
            };
          };
        });
        default = [];
        description = "Key-loading services generated before zfs-mount.service.";
      };
    };

    config = {
      networking.hostId = lib.mkIf (cfg.hostId != null) cfg.hostId;

      boot = {
        supportedFilesystems = ["zfs"];

        zfs = {
          forceImportRoot = false;
          forceImportAll = false;
          inherit (cfg) extraPools;
        };

        kernelParams = [
          "zfs.zfs_arc_max=${toString cfg.arcMax}"
          "zfs.zfs_arc_min=${toString cfg.arcMin}"
        ];
      };

      services.zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };

      systemd.services = builtins.listToAttrs (map mkKeyService cfg.keyLoads);
    };
  };
}
