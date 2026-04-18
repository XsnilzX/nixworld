{
  inputs,
  ...
}: let
  homeModules = import ../../modules/home;
in {
  imports = [
    ./desktop.nix
    inputs.niri.homeModules.niri
    homeModules.desktop.waybar
    homeModules.desktop.swaync
    homeModules.desktop.wleave
  ];

  programs.swaylock.enable = true;

  modules.waybar = {
    enable = true;
    compositor = "niri";
    stylix.enable = true;
  };
}
