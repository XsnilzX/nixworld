{self, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ./ssh.nix
    ./configuration.nix
    ../../profiles/nixos/homelab-server.nix
    self.nixosModules.services-matrix-tuwunel
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "homelab";
}
