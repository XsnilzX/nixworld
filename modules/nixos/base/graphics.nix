_: {
  flake.nixosModules.base-graphics = _: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
