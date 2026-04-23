{...}: {
  flake.homeModules.desktop-waybar-config = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.waybar;
  in {
    config = lib.mkIf cfg.enable {
      programs.waybar.settings.mainBar = {
        layer = "top";
        position = "top";
        inherit (cfg.settings) height spacing;

        modules-left = ["niri/workspaces"];
        modules-center = ["clock"];
        modules-right = [
          "cpu"
          "memory"
          "battery"
          "backlight"
          "pulseaudio"
          "power-profiles-daemon"
          "custom/notification"
          "custom/separator"
          "tray"
          "custom/exit"
        ];

        cpu = {
          interval = 1;
          format = " {usage}%";
        };

        memory = {
          interval = 2;
          format = " {used:0.1f}GB";
        };

        battery = {
          format = " {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
        };

        backlight = {
          format = " {percent}%";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
            headphone = "";
            headset = "";
            hands-free = "";
            phone = "";
            portable = "";
            car = "";
          };
          on-click = "pavucontrol";
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power Profile: {icon} {profile}";
          format-icons = {
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/separator" = {
          format = "|";
          tooltip = false;
        };

        "custom/exit" = {
          format = "⏻";
          on-click = "wleave";
          tooltip = false;
        };

        tray = {
          spacing = 5;
          icon-size = 18;
          tooltip = false;
        };
      };
    };
  };
}
