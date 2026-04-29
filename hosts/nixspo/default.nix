{
  inputs,
  pkgs,
  self,
  ...
}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ./ssh.nix
    inputs.stylix.nixosModules.stylix
    ./stylix.nix
    ../../profiles/nixos/niri.nix
    ../../profiles/nixos/laptop.nix
    ../../profiles/nixos/dev.nix
    self.nixosModules.networking-eduroam
    self.nixosModules.networking-luh-vpn
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

    kernelParams = [
      "amd_pstate=active"
    ];

    plymouth.enable = true;
  };

  networking.hostName = "nixspo";
}
