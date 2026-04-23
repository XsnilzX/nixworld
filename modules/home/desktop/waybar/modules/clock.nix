_: {
  flake.homeModules.desktop-waybar-modules-clock = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.waybar;
  in {
    options.modules.waybar.modules.clock = {
      enable =
        lib.mkEnableOption "clock module"
        // {
          default = true;
        };

      format = lib.mkOption {
        type = lib.types.str;
        default = " {:%H:%M}";
        description = "Clock format string.";
      };

      interval = lib.mkOption {
        type = lib.types.int;
        default = 60;
        description = "Update interval in seconds.";
      };
    };

    config = lib.mkIf (cfg.enable && cfg.modules.clock.enable) {
      programs.waybar.settings.mainBar.clock = {
        inherit (cfg.modules.clock) format interval;
        tooltip = false;
      };
    };
  };
}
