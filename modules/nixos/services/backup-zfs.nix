_: {
  flake.nixosModules.services-backup-zfs = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.zfsBackup;
  in {
    options.services.zfsBackup = {
      enable = lib.mkEnableOption "sanoid and syncoid backup jobs";

      sanoidDatasets = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            useTemplate = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = ["production"];
              description = "Sanoid template names used for this dataset.";
            };

            recursive = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether sanoid should recurse into children.";
            };
          };
        });
        default = {};
        description = "Datasets managed by sanoid.";
      };

      syncoidCommands = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            source = lib.mkOption {
              type = lib.types.str;
              description = "Source dataset for syncoid.";
            };

            target = lib.mkOption {
              type = lib.types.str;
              description = "Target dataset for syncoid.";
            };

            recursive = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether syncoid should recurse into child datasets.";
            };

            extraArgs = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
              description = "Additional command-line flags for syncoid.";
            };
          };
        });
        default = {};
        description = "Named syncoid replication jobs.";
      };

      syncoidStartAt = lib.mkOption {
        type = lib.types.str;
        default = "03:00";
        description = "Systemd calendar expression for starting syncoid.";
      };
    };

    config = lib.mkIf cfg.enable {
      services.sanoid = {
        enable = true;
        datasets = cfg.sanoidDatasets;

        templates.production = {
          hourly = 24;
          daily = 30;
          monthly = 6;
          autosnap = true;
          autoprune = true;
        };
      };

      services.syncoid = {
        enable = true;
        commands = cfg.syncoidCommands;
      };

      systemd.services.syncoid.startAt = cfg.syncoidStartAt;
    };
  };
}
