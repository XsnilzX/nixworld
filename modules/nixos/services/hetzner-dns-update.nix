_: {
  flake.nixosModules.services-hetzner-dns-update = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.hetznerDnsUpdate;
    pythonEnv = pkgs.python3.withPackages (ps: with ps; [hcloud]);

    hetznerUpdater = pkgs.writeScriptBin "hetzner-dns-updater" ''
      #!${pythonEnv}/bin/python
      import os
      import sys
      import urllib.request
      from hcloud import Client
      from hcloud._exceptions import APIException
      from hcloud.zones import ZoneRecord

      def fail(msg: str, code: int = 1) -> None:
          print(f"ERROR: {msg}", file=sys.stderr)
          sys.exit(code)

      def get_env_required(name: str) -> str:
          val = os.environ.get(name)
          if not val:
              fail(f"Environment variable {name} is required")
          return val

      def fetch_ip(url: str, timeout: int = 8) -> str:
          with urllib.request.urlopen(url, timeout=timeout) as resp:
              ip = resp.read().decode("utf-8").strip()
          if not ip:
              fail(f"Could not get IP from {url}")
          return ip

      def get_public_ipv4() -> str:
          for url in ("https://api.ipify.org", "https://ipv4.icanhazip.com"):
              try:
                  return fetch_ip(url)
              except Exception:
                  pass
          fail("Could not determine public IPv4 address")

      def get_public_ipv6() -> str:
          for url in ("https://api6.ipify.org", "https://ipv6.icanhazip.com"):
              try:
                  return fetch_ip(url)
              except Exception:
                  pass
          fail("Could not determine public IPv6 address")

      def upsert_rrset(client: Client, zone, name: str, rrtype: str, value: str) -> None:
          rrset = None
          try:
              rrset = client.zones.get_rrset(zone, name, rrtype)
          except APIException as e:
              if str(e.code) != "not_found" and str(e.code) != "404":
                  raise
          if rrset:
              current_values = [r.value for r in rrset.records or []]
              if current_values == [value]:
                  print(f"{rrtype} {name}: unchanged ({value})")
                  return
              action = client.zones.set_rrset_records(rrset, [ZoneRecord(value=value)])
              action.wait_until_finished()
              print(f"{rrtype} {name}: updated -> {value}")
          else:
              client.zones.create_rrset(
                  zone,
                  name=name,
                  type=rrtype,
                  ttl=60,
                  records=[ZoneRecord(value=value)],
              )
              print(f"{rrtype} {name}: created -> {value}")

      def main() -> None:
          token = get_env_required("API_TOKEN")
          zone_name = get_env_required("HZN_ZONE")
          name = os.environ.get("HZN_NAME", "@")
          do_ipv6 = os.environ.get("HZN_IPV6", "0") == "1"
          client = Client(token=token)
          try:
              zone = client.zones.get(zone_name)
          except APIException as e:
              fail(f"Zone not found or access denied ({zone_name}): {e}")
          ipv4 = get_public_ipv4()
          upsert_rrset(client, zone, name, "A", ipv4)
          if do_ipv6:
              ipv6 = get_public_ipv6()
              upsert_rrset(client, zone, name, "AAAA", ipv6)

      if __name__ == "__main__":
          try:
              main()
          except APIException as e:
              fail(f"Hetzner API error: code={e.code} message={e.message}")
          except Exception as e:
              fail(str(e))
    '';
  in {
    options.services.hetznerDnsUpdate = {
      enable = lib.mkEnableOption "Hetzner DNS updater";

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Environment file exporting the Hetzner DNS updater credentials.";
      };
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.environmentFile != null;
          message = "services.hetznerDnsUpdate.enable requires environmentFile to be set.";
        }
      ];

      environment.systemPackages = [hetznerUpdater];

      users.users.hetzner = {
        isSystemUser = true;
        group = "hetzner";
      };

      users.groups.hetzner = {};

      systemd.services.hetzner-dyndns-updater = {
        description = "Hetzner DynDNS IP Updater";
        after = ["network-online.target"];
        wants = ["network-online.target"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${hetznerUpdater}/bin/hetzner-dns-updater";
          EnvironmentFile = cfg.environmentFile;
          User = "hetzner";
          Group = "hetzner";
          WorkingDirectory = "/var/lib/hetzner-dyndns";
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          NoNewPrivileges = true;
          StateDirectory = "hetzner-dyndns";
          RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
        };
      };

      systemd.timers.hetzner-dyndns-updater = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "10min";
          Unit = "hetzner-dyndns-updater.service";
          Persistent = true;
        };
      };
    };
  };
}
