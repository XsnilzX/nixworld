_: {
  flake.homeModules.desktop-niri-settings = {
    config,
    pkgs,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        prefer-no-csd = true;

        hotkey-overlay = {
          hide-not-bound = true;
        };

        layout = {
          focus-ring = {
            enable = true;
            width = 2;
            active = {
              gradient = {
                from = "#33ccffee";
                to = "#00ff99ee";
                angle = 45;
              };
            };
            inactive.color = "#595959aa";
          };

          gaps = 6;
        };

        input = {
          keyboard.xkb.layout = "de";

          touchpad = {
            click-method = "clickfinger";
            dwt = true;
            natural-scroll = true;
            scroll-method = "two-finger";
            tap = true;
            tap-button-map = "left-right-middle";
            middle-emulation = true;
            accel-profile = "adaptive";
          };

          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = false;
        };

        outputs = {
          "eDP-1" = {
            mode = {
              width = 2880;
              height = 1800;
              refresh = 120.001;
            };
            scale = 1.8;
            position = {
              x = 0;
              y = 0;
            };
          };
        };

        screenshot-path = "${config.home.homeDirectory}/Bilder/Screenshots from %Y-%m-%d %H-%M-%S.png";

        cursor = {
          hide-when-typing = true;
          hide-after-inactive-ms = 2000;
        };

        environment = {
          CLUTTER_BACKEND = "wayland";
          GDK_BACKEND = "wayland,x11";
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATIONS = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          XDG_SESSION_TYPE = "wayland";
          XDG_CURRENT_DESKTOP = "niri";
          DISPLAY = ":0";
        };
      };
    };
  };
}
