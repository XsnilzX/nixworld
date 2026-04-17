{...}: let
  nixosModules = import ../../modules/nixos;
in {
  imports = [
    ./desktop.nix
  ];
}
