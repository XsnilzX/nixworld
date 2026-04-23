{...}: {
  flake.homeModules.desktop-waybar-modules-niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.modules.waybar;
    isNiri = cfg.compositor == "niri";
  in {
    options.modules.waybar.modules.niri = {
      workspaces = {
        enable =
          lib.mkEnableOption "niri workspaces"
          // {
            default = isNiri;
          };

        format = lib.mkOption {
          type = lib.types.str;
          default = "{name}";
          description = "Workspace format. {name} and {index} are available.";
        };

        allOutputs = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show workspaces from all outputs.";
        };
      };

      window = {
        enable =
          lib.mkEnableOption "niri window title"
          // {
            default = isNiri;
          };

        max-length = lib.mkOption {
          type = lib.types.int;
          default = 50;
        };
      };

      picker = {
        enable =
          lib.mkEnableOption "niri screenshot picker"
          // {
            default = false;
          };

        format = lib.mkOption {
          type = lib.types.str;
          default = "󰍉";
        };
      };
    };

    config = lib.mkIf (cfg.enable && isNiri) {
      programs.waybar.settings.mainBar = lib.mkMerge [
        (lib.mkIf cfg.modules.niri.workspaces.enable {
          "niri/workspaces" = {
            inherit (cfg.modules.niri.workspaces) format;
            on-click = "niri msg action focus-workspace {index}";
            all-outputs = cfg.modules.niri.workspaces.allOutputs;
          };
        })

        (lib.mkIf cfg.modules.niri.window.enable {
          "niri/window" = {
            inherit (cfg.modules.niri.window) max-length;
            separate-outputs = true;
          };
        })

        (lib.mkIf cfg.modules.niri.picker.enable {
          "custom/niri-picker" = {
            inherit (cfg.modules.niri.picker) format;
            on-click = "niri msg action screenshot";
            tooltip-format = "Screenshot (Mod+Shift+S)";
          };
        })
      ];

      home.packages = with pkgs; [
        niri
        wl-clipboard
      ];
    };
  };
}
