_: {
  flake.nixosModules.services-headscale = {
    config,
    lib,
    domain ? "example.invalid",
    ...
  }: let
    cfg = config.services.homelabHeadscale;
  in {
    options.services.homelabHeadscale = {
      enable = lib.mkEnableOption "homelab Headscale service wiring";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "headscale.${domain}";
        description = "Public hostname for the Headscale coordination server.";
      };

      tailnetDomain = lib.mkOption {
        type = lib.types.str;
        default = "tailnet.${domain}";
        description = "MagicDNS base domain for Headscale clients.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "Local port Headscale listens on behind Caddy.";
      };

      prepareSubnetRouting = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Document that this deployment is intended to support later subnet route approval.";
      };
    };

    config = lib.mkIf cfg.enable {
      services.headscale = {
        enable = true;
        address = "127.0.0.1";
        inherit (cfg) port;

        settings = {
          server_url = "https://${cfg.domain}";

          log = {
            level = "info";
            format = "json";
          };

          database = {
            type = "sqlite";
            sqlite = {
              path = "/var/lib/headscale/db.sqlite";
              write_ahead_log = true;
            };
          };

          dns = {
            magic_dns = true;
            base_domain = cfg.tailnetDomain;
            override_local_dns = true;
            nameservers.global = [
              "10.0.20.1"
              "1.1.1.1"
            ];
            search_domains = [cfg.tailnetDomain];
          };

          prefixes = {
            v4 = "100.64.0.0/10";
            v6 = "fd7a:115c:a1e0::/48";
            allocation = "random";
          };

          derp = {
            urls = ["https://controlplane.tailscale.com/derpmap/default"];
            auto_update_enabled = true;
            update_frequency = "24h";
          };
        };
      };

      services.caddy.virtualHosts = lib.mkIf config.services.caddy.enable {
        "${cfg.domain}".extraConfig = ''
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

          reverse_proxy 127.0.0.1:${toString cfg.port}
        '';
      };

      environment.etc."headscale/subnet-routing.md" = lib.mkIf cfg.prepareSubnetRouting {
        text = ''
          # Headscale subnet routing

          This host is prepared to approve subnet routes, but no route is enabled automatically.

          On a Tailnet client in the 10.0.20.0/24 LAN:

              sudo tailscale up \
                --login-server https://${cfg.domain} \
                --advertise-routes=10.0.20.0/24

          On the Headscale server:

              sudo headscale routes list
              sudo headscale routes enable --route <ROUTE_ID>
        '';
      };
    };
  };
}
