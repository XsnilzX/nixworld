{...}: {
  flake.homeModules.desktop-video = {
    programs.mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
    };
  };
}
