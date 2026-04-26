{self, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ./ssh.nix
    ./configuration.nix
    ../../profiles/nixos/homelab-server.nix
    self.nixosModules.hardware-nvidia-server
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "home34b";
}
