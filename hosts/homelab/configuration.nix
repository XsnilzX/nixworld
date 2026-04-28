{
  config,
  domain,
  lib,
  ...
}: {
  networking = {
    networkmanager.enable = lib.mkForce false;

    interfaces.enp2s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.0.20.10";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "10.0.20.1";
    nameservers = [
      "10.0.20.1"
      "1.1.1.1"
    ];
  };

  sops = {
    secrets = {
      hetznerDnsEnv = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "hetzner_dns/env";
        owner = "hetzner";
        group = "hetzner";
        mode = "0400";
      };

      caddyCrowdsecApiKey = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "crowdsec/caddy_api_key";
        owner = "caddy";
        group = "caddy";
        mode = "0400";
      };

      n8nEncryptionKey = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "n8n/encryption_key";
        mode = "0400";
      };

      n8nDbPassword = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "n8n/db_password";
        owner = "postgres";
        group = "postgres";
        mode = "0400";
      };

      harmoniaSignKey = {
        sopsFile = ../../secrets/homelab.yaml;
        key = "harmonia/sign_key";
        owner = "harmonia";
        group = "harmonia";
        mode = "0400";
      };
    };

    templates.caddyCrowdsecEnv = {
      content = ''
        CROWDSEC_API_KEY=${config.sops.placeholder.caddyCrowdsecApiKey}
      '';
      owner = "caddy";
      group = "caddy";
      mode = "0400";
    };
  };

  services = {
    hetznerDnsUpdate = {
      enable = true;
      environmentFile = config.sops.secrets.hetznerDnsEnv.path;
    };

    homelabN8n = {
      enable = true;
      encryptionKeySecret = "n8nEncryptionKey";
      dbPasswordSecret = "n8nDbPassword";
    };

    jellyfin.enable = true;

    n8n.environment.WEBHOOK_URL = "https://n8n.${domain}";

    harmonia = {
      enable = true;
      signKeyPaths = [config.sops.secrets.harmoniaSignKey.path];
      settings = {
        bind = "127.0.0.1:5000";
        workers = 4;
        max_connection_rate = 256;
        priority = 40;
        #enable_compression = true;
        real_nix_store = "/Big-Data/nix/store";
      };
    };

    caddy = {
      enable = true;
      enableCrowdsec = true;
      email = "richard@taesler.net";
      enableReload = false;
      environmentFile = config.sops.templates.caddyCrowdsecEnv.path;
      globalConfig = ''
        email richard@taesler.net
        admin off

        servers {
          protocols h1 h2 h3
        }

        order crowdsec first

        crowdsec {
          api_url http://127.0.0.1:8080
          api_key {$CROWDSEC_API_KEY}
        }
      '';
      virtualHosts = let
        securityHeaders = ''
          encode zstd gzip

          tls {
            protocols tls1.2 tls1.3
          }

          log {
            output file /var/log/caddy/access.log
            format json
          }

          rate_limit {
            zone global {
              key {remote_host}:{host}
              events 600
              window 1m
            }
          }

          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
            X-Content-Type-Options "nosniff"
            X-Frame-Options "SAMEORIGIN"
            Referrer-Policy "strict-origin-when-cross-origin"
            Permissions-Policy "camera=(), microphone=(), geolocation=()"
            -Server
          }

          crowdsec
        '';
        mkProxy = upstream: {
          extraConfig = ''
            ${securityHeaders}
            reverse_proxy ${upstream}
          '';
        };
      in {
        "cache.${domain}" = {
          extraConfig = ''
            ${securityHeaders}
            reverse_proxy 127.0.0.1:5000
          '';
        };
        "immich.${domain}" = mkProxy "localhost:2283";
        "cloud.${domain}" = mkProxy "10.0.20.8:9200";
        "collabora.${domain}" = mkProxy "10.0.20.8:9980";
        "wopiserver.${domain}" = mkProxy "10.0.20.8:9300";
        "ai.${domain}" = mkProxy "10.0.20.8:8080";
        "vw.${domain}" = mkProxy "10.0.20.8:11001";
        "n8n.${domain}" = mkProxy "localhost:5678";
      };
    };

    docker.waitForZfs = true;

    zfsExtra = {
      hostId = "ee24c46a";
      extraPools = [
        "Big-Data"
        "ssdpool"
      ];
      arcMax = 6442450944;
      arcMin = 1073741824;
      keyLoads = [
        {
          name = "big-data";
          pool = "Big-Data";
          keyFile = "/etc/zfs/keys/big-data.key";
        }
        {
          name = "ssdpool";
          pool = "ssdpool";
          keyFile = "/etc/zfs/keys/dockerpool.key";
        }
      ];
    };

    zfsBackup = {
      enable = true;
      sanoidDatasets = {
        "ssdpool/services" = {
          useTemplate = ["production"];
          recursive = true;
        };
        "Big-Data/immich".useTemplate = ["production"];
        "Big-Data/jellyfin".useTemplate = ["production"];
      };
      syncoidCommands = {
        "ssdpool-services" = {
          source = "ssdpool/services";
          target = "Big-Data/backup/services";
          recursive = true;
          extraArgs = ["--recvoptions=x encryption"];
        };
        "big-data-immich" = {
          source = "Big-Data/immich";
          target = "Big-Data/backup/immich";
          extraArgs = ["--recvoptions=x encryption"];
        };
        "big-data-jellyfin" = {
          source = "Big-Data/jellyfin";
          target = "Big-Data/backup/jellyfin";
          extraArgs = ["--recvoptions=x encryption"];
        };
      };
      syncoidStartAt = "03:00";
    };

    openssh.listenAddresses = [
      {
        addr = "10.0.20.10";
        port = 22;
      }
    ];

    monitoringStack = {
      enable = true;
      caddy = {
        enable = true;
        grafanaSite = "grafana.${domain}";
        prometheusSite = "prometheus.${domain}";
      };
    };

    homelabCrowdsec = {
      enable = true;
      enableFirewallRules = true;
      sshAllowedCidrs = [
        "10.0.10.0/24"
        "10.0.20.0/24"
        "10.0.40.0/28"
        "192.168.1.0/28"
      ];
      dropOtherSsh = true;
    };

    matrix-tuwunel.enable = true;
  };

  systemd.services.harmonia = {
    after = ["zfs-mount.service"];
    requires = ["zfs-mount.service"];
  };

  systemd.tmpfiles.rules = [
    "d /Big-Data 0755 root root -"
    "d /Big-Data/nix 0755 root root -"
    "d /Big-Data/nix/store 0755 root root -"
  ];

  system.stateVersion = lib.mkForce "25.11";
}
