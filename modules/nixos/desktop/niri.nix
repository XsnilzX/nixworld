_: {
  flake.nixosModules.desktop-niri = {
    lib,
    pkgs,
    ...
  }: {
    programs.niri.enable = true;

    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    services = {
      blueman.enable = true;
      displayManager.ly.enable = true;
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
    };
  };
}
