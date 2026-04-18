{
  inputs,
  pkgs,
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
    ../../profiles/nixos/dev.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

    kernelParams = [
      "amd_pstate=active"
    ];
  };

  networking.hostName = "nixspo";
}
