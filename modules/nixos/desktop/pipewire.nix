_: {
  flake.nixosModules.desktop-pipewire = _: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
