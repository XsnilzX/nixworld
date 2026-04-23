_: {
  flake.homeModules.desktop-gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      prismlauncher
      lunar-client
      heroic
      mangohud
      goverlay
      protonplus
    ];
  };
}
