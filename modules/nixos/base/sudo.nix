{...}: {
  flake.nixosModules.base-sudo = {...}: {
    security = {
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = true;
      };
    };
  };
}
