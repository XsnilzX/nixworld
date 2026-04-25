_: {
  flake.homeModules.desktop-swaylock = {config, ...}: {
    programs.swaylock = {
      enable = true;
      settings = {
        image = "/home/${config.home.username}/Bilder/Wallpaper/sunset-alone-in-desert-scenery-digital-art.jpg";
      };
    };
  };
}
