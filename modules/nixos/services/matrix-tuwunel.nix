_: {
  flake.nixosModules.services-matrix-tuwunel = {
    config,
    domain ? null,
    lib,
    ...
  }: let
    securityHeaders = ''
      encode zstd gzip

      tls {
        protocols tls1.2 tls1.3
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
  in {
    config = lib.mkIf config.services.matrix-tuwunel.enable {
      services.matrix-tuwunel = {
        settings.global = {
          server_name = domain;
          port = [8008];
          address = ["127.0.0.1" "::1"];
          allow_registration = false;
          allow_federation = false;
          log = "warn";
          max_request_size = 20000000;
        };
      };

      services.caddy.virtualHosts = lib.mkIf config.services.caddy.enable {
        "${domain}" = {
          extraConfig = ''
            ${securityHeaders}

            handle /.well-known/matrix/client {
              header Content-Type application/json
              header Access-Control-Allow-Origin *
              respond `{"m.homeserver":{"base_url":"https://matrix.${domain}"}}` 200
            }

            handle /.well-known/matrix/server {
              header Content-Type application/json
              respond `{"m.server":"matrix.${domain}:443"}` 200
            }
          '';
        };

        "matrix.${domain}" = {
          extraConfig = ''
            ${securityHeaders}

            reverse_proxy /_matrix/* localhost:6167 {
              header_up Host {host}
              header_up X-Real-IP {remote_host}
              header_up X-Forwarded-For {remote_host}
              header_up X-Forwarded-Proto {scheme}
            }

            reverse_proxy /_tuwunel/* localhost:6167 {
              header_up Host {host}
            }
          '';
        };
      };
    };
  };
}
