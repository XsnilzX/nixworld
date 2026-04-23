_: {
  flake.nixosModules.base-sudo = _: {
    security = {
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = true;
      };
    };
  };
}
