_: {
  flake.nixosModules.networking-luh-vpn = {
    config,
    lib,
    pkgs,
    ...
  }: {
    sops.secrets."luh-vpn-env" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    sops.secrets."luh-vpn-password" = {
      owner = "root";
      group = "root";
      mode = "0400";
    };

    networking.networkmanager = {
      enable = lib.mkDefault true;
      plugins = with pkgs; [networkmanager-openconnect];

      ensureProfiles = {
        environmentFiles = [config.sops.secrets."luh-vpn-env".path];

        profiles."luh-vpn" = {
          connection = {
            id = "LUH VPN";
            type = "vpn";
            autoconnect = false;
            permissions = "";
          };

          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            gateway = "vpn-server.uni-hannover.de";
            authtype = "password";
            username = "$LUH_VPN_USERNAME";
            password-flags = "1";
            useragent = "AnyConnect";
            cacert = "/etc/ssl/certs/ca-bundle.crt";
          };

          ipv4.method = "auto";
          ipv6.method = "auto";
        };

        secrets.entries = [
          {
            matchId = "LUH VPN";
            matchType = "vpn";
            matchSetting = "vpn";
            key = "password";
            file = config.sops.secrets."luh-vpn-password".path;
          }
        ];
      };
    };

    environment.systemPackages = with pkgs; [openconnect];
  };
}
