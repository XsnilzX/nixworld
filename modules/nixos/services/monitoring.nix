_: {
  flake.nixosModules.services-monitoring = {
    config,
    lib,
    ...
  }: let
    inherit (lib) hasInfix mkDefault mkEnableOption mkIf mkMerge mkOption optionalString optionals types;
    cfg = config.services.monitoringStack;
    caddyMetricsCfg = cfg.caddy.metrics;
    caddyMetricsEnabled = cfg.caddy.enable && caddyMetricsCfg.enable;
    mkPrometheusTarget = address: port:
      if hasInfix ":" address
      then "[${address}]:${toString port}"
      else "${address}:${toString port}";
  in {
    options.services.monitoringStack = {
      enable = mkEnableOption "Prometheus, Grafana and Node Exporter stack";

      prometheus = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable the Prometheus server.";
        };

        listenAddress = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "Address Prometheus should bind to.";
        };

        port = mkOption {
          type = types.port;
          default = 9090;
          description = "TCP port used by Prometheus.";
        };
      };

      grafana = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Grafana.";
        };

        listenAddress = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "Address Grafana should bind to.";
        };

        port = mkOption {
          type = types.port;
          default = 3000;
          description = "TCP port used by Grafana.";
        };
      };

      nodeExporter = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable the Prometheus node exporter.";
        };

        listenAddress = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "Address node exporter should bind to.";
        };

        port = mkOption {
          type = types.port;
          default = 9100;
          description = "TCP port used by the node exporter.";
        };
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Open monitoring ports on the firewall.";
      };

      extraScrapeConfigs = mkOption {
        type = types.listOf types.attrs;
        default = [];
        description = "Additional Prometheus scrape jobs.";
      };

      caddy = {
        enable = mkEnableOption "Expose Grafana and Prometheus through Caddy";

        grafanaSite = mkOption {
          type = types.str;
          default = "http://grafana";
          description = "Caddy site label used for Grafana.";
        };

        prometheusSite = mkOption {
          type = types.str;
          default = "http://prometheus";
          description = "Caddy site label used for Prometheus.";
        };

        metrics = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Expose local Caddy metrics for Prometheus scraping.";
          };

          listenAddress = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address the local Caddy metrics endpoint should bind to.";
          };

          port = mkOption {
            type = types.port;
            default = 2019;
            description = "TCP port used by the local Caddy metrics endpoint.";
          };
        };
      };
    };

    config = mkIf cfg.enable (mkMerge [
      {
        assertions = [
          {
            assertion = !cfg.caddy.enable || config.services.caddy.enable;
            message = "services.monitoringStack.caddy.enable requires services.caddy.enable.";
          }
          {
            assertion = !caddyMetricsEnabled || config.services.caddy.enable;
            message = "services.monitoringStack.caddy.metrics.enable requires services.caddy.enable.";
          }
          {
            assertion = !caddyMetricsEnabled || cfg.prometheus.enable;
            message = "services.monitoringStack.caddy.metrics.enable requires services.monitoringStack.prometheus.enable.";
          }
        ];

        networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall (
          optionals cfg.grafana.enable [cfg.grafana.port]
          ++ optionals cfg.prometheus.enable [cfg.prometheus.port]
          ++ optionals cfg.nodeExporter.enable [cfg.nodeExporter.port]
        );

        services = {
          prometheus = mkMerge [
            (mkIf cfg.prometheus.enable {
              enable = true;
              inherit (cfg.prometheus) listenAddress port;
              scrapeConfigs =
                optionals cfg.nodeExporter.enable [
                  {
                    job_name = "nixos-local";
                    static_configs = [
                      {
                        targets = ["127.0.0.1:${toString cfg.nodeExporter.port}"];
                      }
                    ];
                  }
                ]
                ++ optionals caddyMetricsEnabled [
                  {
                    job_name = "caddy-local";
                    metrics_path = "/metrics";
                    static_configs = [
                      {
                        targets = [
                          (mkPrometheusTarget caddyMetricsCfg.listenAddress caddyMetricsCfg.port)
                        ];
                      }
                    ];
                  }
                ]
                ++ cfg.extraScrapeConfigs;
            })
            (mkIf cfg.nodeExporter.enable {
              exporters.node = {
                enable = true;
                inherit (cfg.nodeExporter) listenAddress port;
              };
            })
          ];

          grafana = mkIf cfg.grafana.enable {
            enable = true;

            settings.server = {
              http_addr = cfg.grafana.listenAddress;
              http_port = cfg.grafana.port;
            };

            provision = {
              enable = true;
              datasources.settings = {
                apiVersion = 1;
                datasources = [
                  {
                    name = "Prometheus";
                    type = "prometheus";
                    access = "proxy";
                    url = "http://127.0.0.1:${toString cfg.prometheus.port}";
                    isDefault = true;
                  }
                ];
              };
            };
          };
        };
      }
      (mkIf cfg.caddy.enable {
        services.monitoringStack = {
          openFirewall = mkDefault false;

          grafana.listenAddress = mkDefault "127.0.0.1";
          prometheus.listenAddress = mkDefault "127.0.0.1";
          nodeExporter.listenAddress = mkDefault "127.0.0.1";
        };

        services.caddy = {
          globalConfig = optionalString caddyMetricsEnabled ''
            metrics {
              per_host
            }
          '';

          virtualHosts = mkMerge [
            (mkIf cfg.grafana.enable {
              "${cfg.caddy.grafanaSite}" = {
                extraConfig = ''
                  reverse_proxy 127.0.0.1:${toString cfg.grafana.port}
                '';
              };
            })
            (mkIf cfg.prometheus.enable {
              "${cfg.caddy.prometheusSite}" = {
                extraConfig = ''
                  reverse_proxy 127.0.0.1:${toString cfg.prometheus.port}
                '';
              };
            })
            (mkIf caddyMetricsEnabled {
              ":${toString caddyMetricsCfg.port}" = {
                listenAddresses = [caddyMetricsCfg.listenAddress];
                logFormat = ''
                  output discard
                '';
                extraConfig = ''
                  metrics /metrics
                '';
              };
            })
          ];
        };
      })
    ]);
  };
}
