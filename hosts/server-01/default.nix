{...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ./ssh.nix
    ../../profiles/nixos/server.nix
  ];

  networking.hostName = "server-01";
}
