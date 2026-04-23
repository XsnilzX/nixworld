{...}: {
  flake.nixosModules.hardware-bluetooth = {...}: {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
