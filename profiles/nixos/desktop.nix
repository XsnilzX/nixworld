{...}: let
  nixosModules = import ../../modules/nixos;
in {
  imports = [
    ./base.nix
    nixosModules.desktop.cachyosKernel
    nixosModules.desktop.kde
    nixosModules.desktop.pipewire
    nixosModules.desktop.steam
    nixosModules.hardware.bluetooth
  ];

  services.fstrim.enable = true;
}
