{...}: {
  flake.nixosModules.services-tailscale = {lib, ...}: {
    services.tailscale = {
      enable = lib.mkDefault true;
      openFirewall = true;
    };
  };
}
