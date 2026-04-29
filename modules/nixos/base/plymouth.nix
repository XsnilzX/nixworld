_: {
  flake.nixosModules.base-plymouth = _: {
    boot.plymouth.enable = true;
  };
}
