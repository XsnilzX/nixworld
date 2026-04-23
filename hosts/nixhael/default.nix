{pkgs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./disko.nix
    ./ssh.nix
    ../../profiles/nixos/desktop.nix
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

  powerManagement.cpuFreqGovernor = "performance";

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/0597ed78-f294-469a-8d73-01b81a7573c3";
    fsType = "ext4";
    options = ["defaults"];
  };

  networking.hostName = "nixhael";
}
