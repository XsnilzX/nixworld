{ config, lib, ... }:
{
  services.caddy = {
    enable = lib.mkDefault false;
    email = lib.mkDefault "admin@example.invalid";
  };
}
// lib.mkIf config.services.caddy.enable {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
