{
  inputs,
  lib,
  pkgs,
  config,
  hostname,
  self,
  ...
}: {
  imports =
    [
      inputs.zen-browser.homeModules.beta
      self.homeModules.desktop-audio
      self.homeModules.desktop-email
      self.homeModules.desktop-ghostty
      self.homeModules.desktop-images
      self.homeModules.desktop-pdf
      self.homeModules.desktop-recording
      self.homeModules.desktop-video
      self.homeModules.desktop-writing
    ]
    ++ lib.optionals (hostname == "nixhael") [
      self.homeModules.desktop-gaming
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
      languagePacks = ["de"];
      policies = {
        ShowHomeButton = true;
        DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";
        DisableTelemetry = true;
        ExtensionSettings = {
          "Bitwarden" = {
            default_area = "menupanel";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };
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
