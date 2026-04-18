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
      availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod"];
      kernelModules = [];
      luks.devices."crypted" = {
        device = "/dev/disk/by-uuid/a209e58a-a032-40f8-8b9c-d268c9a5b3e6";
        allowDiscards = true;
      };
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };
  console.keyMap = "de";

  fileSystems = {
    "/" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd:4" "noatime" "ssd" "discard=async" "space_cache=v2"];
    };

    "/nix" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=@nix" "noatime" "nodatacow" "ssd" "discard=async" "space_cache=v2"];
    };

    "/home" = {
      device = "/dev/mapper/crypted";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd:4" "noatime" "ssd" "discard=async" "space_cache=v2"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/e5431bd3-f366-4a19-8cae-b3cb219d79ca";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
