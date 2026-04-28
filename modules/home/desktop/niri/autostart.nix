_: {
  flake.homeModules.desktop-niri-autostart = {
    programs.niri.settings.spawn-at-startup = [
      {command = ["swayidle"];}
      {command = ["swaync"];}
      {command = ["awww-daemon"];}
      {command = ["nm-applet" "--indicator"];}
      {command = ["blueman-applet"];}
      {command = ["seafile-applet"];}
      {command = ["systemctl" "--user" "start" "polkit-gnome-authentication-agent-1"];}
    ];
  };
}
