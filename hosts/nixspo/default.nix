{...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ../../profiles/nixos/desktop.nix
    ../../profiles/nixos/dev.nix
  ];

  networking.hostName = "nixspo";
  sops.defaultSopsFile = ../../secrets/nixspo.yaml;
}
