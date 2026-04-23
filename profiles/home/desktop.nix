{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.desktop-audio
    self.homeModules.desktop-email
    self.homeModules.desktop-gaming
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

    proton-vpn

    element-desktop
    discord
    mumble

    helium
  ];

  xdg.desktopEntries.discord = {
    name = "Discord";
    genericName = "All-in-one voice and text chat";
    exec = "discord --ozone-platform=wayland";
    icon = "discord";
    type = "Application";
    categories = ["Network" "InstantMessaging"];
  };
}
