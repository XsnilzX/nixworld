_: {
  flake.homeModules.desktop-niri-config = {
    pkgs,
    self,
    ...
  }: {
    imports = [
      self.homeModules.desktop-niri-applications
      self.homeModules.desktop-niri-settings
      self.homeModules.desktop-niri-keybinds
      self.homeModules.desktop-niri-autostart
      self.homeModules.desktop-niri-services
    ];

    home.packages = with pkgs; [
      playerctl
    ];
  };
}
