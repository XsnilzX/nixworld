{
  inputs,
  pkgs,
  config,
  self,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
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

  programs = {
    zen-browser = {
      enable = true;
      setAsDefaultBrowser = false;
      languagePacks = ["de" "en-US"];
    };

    firefox = {
      enable = true;
      languagePacks = ["de" "en-US"];
      policies = {
        ShowHomeButton = true;
        DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
        DisanleTelemetry = true;
      };
    };
  };

  xdg.desktopEntries.discord = {
    name = "Discord";
    genericName = "All-in-one voice and text chat";
    exec = "discord --ozone-platform=wayland";
    icon = "discord";
    type = "Application";
    categories = ["Network" "InstantMessaging"];
  };
}
