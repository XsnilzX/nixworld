{self, ...}: {
  imports = [
    ./laptop.nix
    self.nixosModules.desktop-niri
  ];
}
