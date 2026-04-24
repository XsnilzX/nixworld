_: {
  flake.homeModules.desktop-waybar-style = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.waybar;
    stylixEnabled = cfg.stylix.enable;

    hexPairToDec = pair: (builtins.fromTOML "value = 0x${pair}").value;

    hexToRgb = hex: let
      normalized = lib.removePrefix "#" hex;
    in "${toString (hexPairToDec (lib.substring 0 2 normalized))}, ${toString (hexPairToDec (lib.substring 2 2 normalized))}, ${toString (hexPairToDec (lib.substring 4 2 normalized))}";

    colors =
      if stylixEnabled
      then {
        bg = config.lib.stylix.colors.base00;
        bg-alt = config.lib.stylix.colors.base01;
        fg = config.lib.stylix.colors.base05;
        fg-alt = config.lib.stylix.colors.base04;
        accent = config.lib.stylix.colors.base0D;
        urgent = config.lib.stylix.colors.base08;
        success = config.lib.stylix.colors.base0B;
        warning = config.lib.stylix.colors.base0A;
      }
      else {
        bg = "1e1e2e";
        bg-alt = "313244";
        fg = "cdd6f4";
        fg-alt = "a6adc8";
        accent = "89b4fa";
        urgent = "f38ba8";
        success = "a6e3a1";
        warning = "f9e2af";
      };

    font =
      if stylixEnabled
      then {
        inherit (config.stylix.fonts.sansSerif) name;
        size = config.stylix.fonts.sizes.popups;
      }
      else {
        name = "JetBrainsMono Nerd Font";
        size = 13;
      };

    borderRadius =
      if stylixEnabled
      then config.stylix.roundness or 0
      else 16;

    popupOpacity =
      if stylixEnabled
      then config.stylix.opacity.popups or 0.85
      else 0.85;
  in {
    config = lib.mkIf cfg.enable {
      programs.waybar.style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "${font.name}", "Font Awesome 7 Free", monospace;
          font-size: ${toString font.size}px;
          min-height: 0;
          color: #${colors.fg};
        }

        window#waybar {
          background: transparent;
        }

        .modules-left,
        .modules-center,
        .modules-right {
          background: rgba(${hexToRgb colors.bg}, ${toString popupOpacity});
          padding: 2px 6px;
          margin: 2px 4.5px;
          border-radius: ${toString borderRadius}px;
        }

        #workspaces button {
          padding: 0 8px;
          color: #${colors.fg};
          background: transparent;
          border-radius: ${toString borderRadius}px;
        }

        #workspaces button:hover {
          background: rgba(${hexToRgb colors.accent}, 0.2);
          color: #${colors.fg};
        }

        #workspaces button.focused,
        #workspaces button.active {
          background: #${colors.accent};
          color: #${colors.bg};
        }

        #workspaces button.urgent {
          background: #${colors.urgent};
          color: #${colors.bg};
        }

        #clock,
        #cpu,
        #memory,
        #battery,
        #backlight,
        #pulseaudio,
        #power-profiles-daemon,
        #custom-notification,
        #custom-weather {
          padding: 0 6px;
        }

        #clock,
        #tray,
        #custom-exit {
          padding: 0 4px;
        }

        #custom-separator {
          color: #${colors.fg-alt};
          font-size: ${toString (font.size + 4)}px;
        }

        #custom-exit {
          font-family: "Font Awesome 7 Free", "${font.name}", sans-serif;
          color: #${colors.urgent};
        }

        #battery.charging {
          color: #${colors.success};
        }

        #battery.warning {
          color: #${colors.warning};
        }

        #battery.critical {
          color: #${colors.urgent};
        }

        tooltip {
          background: #${colors.bg};
          border-radius: ${toString (borderRadius / 2)}px;
          padding: 8px;
          opacity: 0.9;
        }

        tooltip label {
          color: #${colors.fg};
        }
      '';
    };
  };
}
