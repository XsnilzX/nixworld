_: {
  flake.nixosModules.services-crowdsec = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.homelabCrowdsec;
    sshAllowRules = map (cidr: "iptables -A INPUT -p tcp --dport 22 -s ${cidr} -j ACCEPT") cfg.sshAllowedCidrs;
    sshDropRules = lib.optional cfg.dropOtherSsh "iptables -A INPUT -p tcp --dport 22 -j DROP";
  in {
    options.services.homelabCrowdsec = {
      enableFirewallRules = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable iptables rules that restrict SSH access to the configured CIDRs.";
      };

      sshAllowedCidrs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "CIDR ranges allowed to connect via SSH.";
      };

      dropOtherSsh = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Drop SSH traffic that does not match sshAllowedCidrs.";
      };
    };

    config = {
      services = {
        crowdsec = {
          enable = lib.mkDefault false;
          settings.general.api.server = {
            enable = true;
            listen_uri = "127.0.0.1:8080";
          };
          settings.lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
          hub.collections = [
            "crowdsecurity/linux"
            "crowdsecurity/caddy"
          ];
          localConfig.acquisitions = [
            {
              source = "journalctl";
              journalctl_filter = ["_SYSTEMD_UNIT=sshd.service"];
              labels.type = "syslog";
            }
            {
              filenames = ["/var/log/caddy/access.log"];
              labels.type = "caddy";
            }
          ];
        };

        "crowdsec-firewall-bouncer".enable = lib.mkDefault config.services.crowdsec.enable;
      };

      networking.firewall.extraCommands = lib.mkIf (cfg.enableFirewallRules && cfg.sshAllowedCidrs != []) (
        lib.concatStringsSep "\n" (sshAllowRules ++ sshDropRules)
      );

      boot.kernel.sysctl = {
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "kernel.kptr_restrict" = 2;
        "kernel.dmesg_restrict" = 1;
      };

      users.users.crowdsec = lib.mkIf config.services.crowdsec.enable {
        isSystemUser = true;
        group = "crowdsec";
        extraGroups = ["caddy"];
      };

      users.groups.crowdsec = lib.mkIf config.services.crowdsec.enable {};

      systemd.tmpfiles.rules = lib.mkIf config.services.crowdsec.enable [
        "d /var/lib/crowdsec 0755 crowdsec crowdsec - -"
      ];

      systemd.services.caddy = lib.mkIf (config.services.crowdsec.enable && config.services.caddy.enable) {
        after = ["crowdsec.service"];
        wants = ["crowdsec.service"];
        serviceConfig = {
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
        };
      };
    };
  };
}
