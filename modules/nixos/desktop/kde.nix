_: {
  flake.nixosModules.desktop-kde = _: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      displayManager.sddm.wayland.enable = true;
    };
  };
}
