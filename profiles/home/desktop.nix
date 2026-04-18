{pkgs, ...}: let
  homeModules = import ../../modules/home;
in {
  imports = [
    homeModules.desktop.audio
    homeModules.desktop.ghostty
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
