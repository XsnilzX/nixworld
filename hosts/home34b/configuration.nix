{
  config,
  domain,
  lib,
  ...
}: {
  imports = [
    ../../users/friedrich
    ../../users/jones
  ];

  networking = {
    networkmanager.enable = lib.mkForce false;

    interfaces.enp11s0f0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.178.10";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "192.168.178.1";
    nameservers = [
      "192.168.178.1"
      "1.1.1.1"
    ];
  };

  users.groups = {
    fileshare = {};
    multimedia = {};
  };

  sops.secrets = {
    hetznerDnsEnv = {
      sopsFile = ../../secrets/home34b.yaml;
      key = "hetzner_dns/env";
      owner = "hetzner";
      group = "hetzner";
      mode = "0400";
    };

    friedrichPasswordHash = {
      sopsFile = ../../secrets/home34b.yaml;
      key = "users/friedrich/passwordHash";
      neededForUsers = true;
    };

    jonesPasswordHash = {
      sopsFile = ../../secrets/home34b.yaml;
      key = "users/jones/passwordHash";
      neededForUsers = true;
    };
  };

  users.users = {
    friedrich.hashedPasswordFile = config.sops.secrets.friedrichPasswordHash.path;
    jones.hashedPasswordFile = config.sops.secrets.jonesPasswordHash.path;
  };

  services = {
    hetznerDnsUpdate = {
      enable = true;
      environmentFile = config.sops.secrets.hetznerDnsEnv.path;
    };

    caddy = {
      enable = true;
      enableCrowdsec = false;
      email = "richard@taesler.net";
      enableReload = false;
      globalConfig = ''
        email richard@taesler.net
        admin off

        servers {
          protocols h1 h2 h3
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
        '';
        mkProxy = upstream: {
          extraConfig = ''
            ${securityHeaders}
            reverse_proxy ${upstream}
          '';
        };
      in {
        "immich.${domain}" = mkProxy "localhost:2283";
        "vw.${domain}" = mkProxy "localhost:11001";
      };
    };

    jellyfin.enable = true;

    docker.waitForZfs = true;

    zfsExtra = {
      hostId = "6d8b78c7";
      extraPools = [
        "BigData"
        "dockerpool"
      ];
      arcMax = 6442450944;
      arcMin = 1073741824;
    };

    monitoringStack = {
      enable = true;
      caddy = {
        enable = true;
        grafanaSite = "grafana.${domain}";
        prometheusSite = "prometheus.${domain}";
      };
    };

    sambaShareStack.enable = true;
  };

  system.stateVersion = lib.mkForce "25.11";
}
