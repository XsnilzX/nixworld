{self, ...}: {
  imports = [
    ./desktop-common.nix
    self.nixosModules.desktop-kde
  ];
}
