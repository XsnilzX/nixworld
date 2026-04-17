{pkgs, ...}: let
  homeModules = import ../../modules/home;
in {
  imports = [
    homeModules.cli.git
    homeModules.cli.zsh
  ];

  home.packages = with pkgs; [
    zip
    unzip
    p7zip

    libnotify
    xdg-utils
    fastfetch
    ncdu
    fd
    ripgrep
    bat
  ];

  programs.home-manager.enable = true;
}
