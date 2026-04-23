{
  inputs,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./desktop.nix
    inputs.niri.homeModules.niri
    self.homeModules.desktop-waybar
    self.homeModules.desktop-swaync
    self.homeModules.desktop-wleave
  ];

  programs.swaylock.enable = true;

  home.packages = with pkgs; [
    xwayland-satellite
  ];

  modules.waybar = {
    enable = true;
    compositor = "niri";
    stylix.enable = true;
  };
}
