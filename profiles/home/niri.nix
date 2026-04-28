{
  inputs,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./desktop.nix
    inputs.niri.homeModules.niri
    inputs.goather.homeManagerModules.default
    self.homeModules.desktop-anyrun
    self.homeModules.desktop-niri-config
    self.homeModules.desktop-wallpaperScript
    self.homeModules.desktop-waybar
    self.homeModules.desktop-swaync
    self.homeModules.desktop-swaylock
    self.homeModules.desktop-wleave
  ];

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  modules.waybar = {
    enable = true;
    compositor = "niri";
    stylix.enable = true;
  };
}
