{...}: {
  flake.nixosModules.hardware-bluetooth = {...}: {
    hardware.bluetooth.enable = true;
  };
}
