{...}: let
  nixosModules = import ../../modules/nixos;
in {
  imports = [
    ./desktop-common.nix
    nixosModules.desktop.niri
  ];
}
