{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };
  console.keyMap = "de";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/29fa8ffb-b933-45b1-98cd-6152dfa0a3c4";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd:4" "noatime" "ssd" "discard=async" "space_cache=v2"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/29fa8ffb-b933-45b1-98cd-6152dfa0a3c4";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd:4" "noatime" "ssd" "discard=async" "space_cache=v2"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/29fa8ffb-b933-45b1-98cd-6152dfa0a3c4";
      fsType = "btrfs";
      options = ["subvol=@nix" "noatime" "nodatacow" "ssd" "discard=async" "space_cache=v2"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3F85-4835";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/9f6e0323-023a-40d8-9f48-5927d9d652a8";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    openrazer = {
      enable = true;
      users = ["xsnilzx"];
    };
  };
}
