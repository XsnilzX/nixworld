{ ... }:
let
  nixosModules = import ../../modules/nixos;
in
{
  imports = [
    ./base.nix
    nixosModules.services.tailscale
  ];
}
