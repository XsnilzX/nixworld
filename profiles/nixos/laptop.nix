{self, ...}: {
  imports = [
    ./desktop-common.nix
    self.nixosModules.desktop-niri
  ];
  services = {
    blueman.enable = true;
    udisks2.enable = true;
    openssh.enable = true;
    upower.enable = true;
  };
}
