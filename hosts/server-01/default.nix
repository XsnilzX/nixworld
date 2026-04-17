{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ../../profiles/nixos/server.nix
  ];

  networking.hostName = "server-01";
  sops.defaultSopsFile = ../../secrets/server-01.yaml;
}
