_: {
  flake.nixosModules.services-n8n = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.homelabN8n;
  in {
    options.services.homelabN8n = {
      enable = lib.mkEnableOption "homelab n8n service wiring";

      encryptionKeySecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of the SOPS secret containing the n8n encryption key.";
      };

      dbPasswordSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of the SOPS secret containing the n8n database password.";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.encryptionKeySecret != null && cfg.dbPasswordSecret != null;
          message = "services.homelabN8n requires both encryptionKeySecret and dbPasswordSecret to be set.";
        }
      ];

      users.users.n8n = {
        isSystemUser = true;
        group = "n8n";
      };

      users.groups.n8n = {};

      services.postgresql = {
        enable = true;
        dataDir = "/services/postgresql";
        ensureDatabases = ["n8n"];
        ensureUsers = [
          {
            name = "n8n";
            ensureDBOwnership = true;
          }
        ];
      };

      services.n8n = {
        enable = true;
        environment = {
          DB_TYPE = "postgresdb";
          DB_POSTGRESDB_HOST = "127.0.0.1";
          DB_POSTGRESDB_PORT = "5432";
          DB_POSTGRESDB_DATABASE = "n8n";
          DB_POSTGRESDB_USER = "n8n";
          DB_POSTGRESDB_PASSWORD_FILE = "%d/db_postgresdb_password_file";
          N8N_ENCRYPTION_KEY_FILE = "%d/n8n_encryption_key_file";
          N8N_HOST = "0.0.0.0";
          N8N_PORT = "5678";
          N8N_PROTOCOL = "https";
          EXECUTIONS_MODE = "regular";
          N8N_METRICS = "false";
          N8N_VERSION_NOTIFICATIONS_ENABLED = "false";
          N8N_DIAGNOSTICS_ENABLED = "false";
          GENERIC_TIMEZONE = "Europe/Berlin";
          TZ = "Europe/Berlin";
        };
      };

      systemd = {
        services = {
          postgresql-n8n-password = {
            description = "Set n8n PostgreSQL password";
            after = ["postgresql.service" "postgresql-setup.service"];
            requires = ["postgresql.service" "postgresql-setup.service"];
            wantedBy = ["multi-user.target"];

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              User = "postgres";
            };

            script = ''
              DB_PASSWORD=$(cat ${config.sops.secrets.${cfg.dbPasswordSecret}.path})
              ${pkgs.postgresql}/bin/psql -c "ALTER USER n8n WITH PASSWORD '$DB_PASSWORD';"
            '';
          };

          n8n = {
            after = ["postgresql-n8n-password.service"];
            requires = ["postgresql-n8n-password.service"];
            environment = {
              N8N_USER_FOLDER = lib.mkForce "/services/n8n/data";
            };
            serviceConfig = {
              LoadCredential = [
                "db_postgresdb_password_file:${config.sops.secrets.${cfg.dbPasswordSecret}.path}"
                "n8n_encryption_key_file:${config.sops.secrets.${cfg.encryptionKeySecret}.path}"
              ];
              User = "n8n";
              Group = "n8n";
              ReadWritePaths = ["/services/n8n/data"];
            };
          };
        };

        tmpfiles.rules = [
          "d /services 0755 root root -"
          "d /services/n8n 0750 n8n n8n -"
          "d /services/n8n/data 0750 n8n n8n -"
          "d /services/n8n/data/.n8n 0750 n8n n8n -"
        ];
      };
    };
  };
}
