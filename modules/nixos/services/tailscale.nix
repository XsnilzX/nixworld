{ lib, ... }:
{
  services.tailscale = {
    enable = lib.mkDefault true;
    openFirewall = true;
  };
}
