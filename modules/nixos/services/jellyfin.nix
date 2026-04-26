_: {
  flake.nixosModules.services-jellyfin = {
    config,
    domain ? null,
    lib,
    pkgs,
    hostname,
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
    config = lib.mkIf config.services.jellyfin.enable {
      users.users.jellyfin.extraGroups = [
        "video"
        "render"
        "multimedia"
      ];

      hardware.graphics = lib.mkIf (hostname == "homelab") {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          libva-vdpau-driver
        ];
      };

      services.jellyfin = {
        openFirewall = false;
        dataDir = "/services/jellyfin/config";
        cacheDir = "/services/jellyfin/cache";
      };

      systemd.services.jellyfin = {
        after = ["zfs-mount.service"];
        requires = ["zfs-mount.service"];
        environment = lib.mkIf (domain != null) {
          JELLYFIN_PublishedServerUrl = "https://jellyfin.${domain}";
        };
      };

      services.caddy.virtualHosts = lib.mkIf (config.services.caddy.enable && domain != null) {
        "jellyfin.${domain}" = {
          extraConfig = ''
            ${securityHeaders}
            reverse_proxy localhost:8096
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "d /services/jellyfin 0750 jellyfin jellyfin -"
        "d /services/jellyfin/config 0750 jellyfin jellyfin -"
        "d /services/jellyfin/cache 0750 jellyfin jellyfin -"
      ];
    };
  };
}
