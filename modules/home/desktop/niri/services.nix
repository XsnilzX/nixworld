_: {
  flake.homeModules.desktop-niri-services = {
    services = {
      swayidle.enable = true;
      polkit-gnome.enable = true;
      udiskie = {
        enable = true;
        tray = "auto";
      };
    };
  };
}
