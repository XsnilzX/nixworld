{...}: {
  flake.homeModules.desktop-waybar = {
    config,
    lib,
    pkgs,
    self,
    ...
  }: let
    cfg = config.modules.waybar;
    supportedCompositors = ["niri"];
  in {
    imports = [
      self.homeModules.desktop-waybar-config
      self.homeModules.desktop-waybar-style
      self.homeModules.desktop-waybar-modules
    ];

    options.modules.waybar = {
      enable = lib.mkEnableOption "Waybar status bar";

      compositor = lib.mkOption {
        type = lib.types.enum supportedCompositors;
        default = "niri";
        description = "Compositor for workspace and window integration.";
      };

      stylix = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      theme = lib.mkOption {
        type = lib.types.enum ["dark"];
        default = "dark";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.waybar;
      };

      settings = {
        height = lib.mkOption {
          type = lib.types.int;
          default = 34;
        };
        spacing = lib.mkOption {
          type = lib.types.int;
          default = 8;
        };
      };
    };

    config = lib.mkMerge [
      (lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = lib.elem cfg.compositor supportedCompositors;
            message = "waybar: compositor '${cfg.compositor}' not supported. Use one of: ${toString supportedCompositors}";
          }
        ];

        home.packages = [cfg.package];

        programs.waybar = {
          enable = true;
          inherit (cfg) package;
          systemd.enable = true;
        };

        programs.niri.settings.spawn-at-startup = lib.mkAfter [
          {command = ["systemctl" "--user" "start" "waybar.service"];}
        ];
      })

      (lib.mkIf (cfg.enable && cfg.stylix.enable) {
        modules.waybar.settings.height = lib.mkDefault (config.stylix.fonts.sizes.popups * 2 + 8);
        stylix.targets.waybar.enable = false;
      })
    ];
  };
}
