{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.desktop-audio
    self.homeModules.desktop-email
    self.homeModules.desktop-ghostty
    self.homeModules.desktop-images
    self.homeModules.desktop-pdf
    self.homeModules.desktop-recording
    self.homeModules.desktop-video
    self.homeModules.desktop-writing
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
