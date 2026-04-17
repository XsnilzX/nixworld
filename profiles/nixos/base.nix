{...}: let
  nixosModules = import ../../modules/nixos;
in {
  imports = [
    nixosModules.base.locale
    nixosModules.base.nixSettings
    nixosModules.base.openssh
    nixosModules.base.sudo
  ];

  networking.firewall.enable = true;
  system.stateVersion = "25.05";
}
