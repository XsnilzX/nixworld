{self, ...}: {
  imports = [
    ./base.nix
    self.nixosModules.services-tailscale
  ];
}
