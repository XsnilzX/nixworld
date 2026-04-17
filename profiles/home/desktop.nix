{pkgs, ...}: let
  homeModules = import ../../modules/home;
in {
  imports = [
    homeModules.desktop.ghostty
    homeModules.desktop.waybar
  ];

  home.packages = with pkgs; [
    amdgpu_top
    seafile-client
    gimp
    qbittorrent
    geogebra6

    mullvad-vpn
    proton-vpn

    element-desktop
    discord
    mumble

    prismlauncher
    lunar-client
    helium
  ];
}
