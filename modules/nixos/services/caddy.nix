_: {
  flake.nixosModules.services-caddy = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.caddy;
  in {
    options.services.caddy.enableCrowdsec = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Build Caddy with CrowdSec and rate-limit plugins enabled.";
    };

    config = lib.mkMerge [
      {
        services.caddy = {
          enable = lib.mkDefault false;
          email = lib.mkDefault "admin@example.invalid";
        };
      }
      (lib.mkIf cfg.enable {
        services.caddy = lib.mkIf cfg.enableCrowdsec {
          package = pkgs.caddy.withPlugins {
            plugins = [
              "github.com/mholt/caddy-ratelimit@v0.1.0"
              "github.com/hslatman/caddy-crowdsec-bouncer@v0.10.0"
            ];
            hash = "sha256-MO6O97pjdOEPDUrJ/rTR4dmFldlaewjFtuujYQNluNY=";
          };
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        systemd.tmpfiles.rules = [
          "d /var/log/caddy 0750 caddy caddy - -"
        ];
      })
    ];
  };
}
