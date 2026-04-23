{...}: {
  flake.homeModules.desktop-waybar-modules = {self, ...}: {
    imports = [
      self.homeModules.desktop-waybar-modules-clock
      self.homeModules.desktop-waybar-modules-niri
    ];
  };
}
