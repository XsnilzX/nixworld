{...}: {
  flake.homeModules.desktop-wleave = {pkgs, ...}: {
    programs.wleave = {
      enable = true;
      settings = {
        buttons-per-row = "2/2";
        delay-commands-ms = 100;
        buttons = [
          {
            label = "lock";
            action = "swaylock";
            text = "Lock";
            keybind = "l";
            icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
          }
          {
            label = "logout";
            action = "loginctl terminate-user $USER";
            text = "Logout";
            keybind = "e";
            icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
          }
          {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
            icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
          }
          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
            icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
          }
        ];
      };
      style = ''
        window {
          background-color: rgba(20, 20, 20, 0.8);
        }

        button {
          color: #f8f8f2;
          background-color: #282a36;
        }

        button:hover,
        button:focus {
          background-color: #44475a;
        }
      '';
    };
  };
}
