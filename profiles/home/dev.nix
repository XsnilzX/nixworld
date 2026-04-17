{pkgs, ...}: let
  homeModules = import ../../modules/home;
in {
  imports = [
    homeModules.cli.uv
    homeModules.dev.common
    homeModules.dev.direnv
  ];

  home.packages = with pkgs; [
    tree
    devbox
  ];
}
