{...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ./ssh.nix
    ../../profiles/nixos/desktop.nix
    ../../profiles/nixos/dev.nix
  ];

  networking.hostName = "nixhael";
}
