_: {
  flake.nixosModules.base-openssh = _: {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
      };
    };
  };
}
