{...}: {
  flake.homeModules.desktop-audio = {pkgs, ...}: {
    home.packages = with pkgs; [
      # audio
      pavucontrol
    ];

    services.playerctld.enable = true;
  };
}
