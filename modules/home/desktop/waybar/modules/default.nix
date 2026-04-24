_: {
  flake.homeModules.desktop-waybar-modules = {self, ...}: {
    imports = [
      self.homeModules.desktop-waybar-modules-clock
      self.homeModules.desktop-waybar-modules-niri
      self.homeModules.desktop-waybar-modules-weather
    ];
  };

  flake.homeModules.desktop-waybar-modules-weather = {
    config,
    lib,
    ...
  }: let
    cfg = config.modules.waybar;
  in {
    options.modules.waybar.modules.weather = {
      enable =
        lib.mkEnableOption "weather module"
        // {
          default = true;
        };

      format = lib.mkOption {
        type = lib.types.str;
        default = "{text}";
        description = "Waybar format string for the weather widget.";
      };

      interval = lib.mkOption {
        type = lib.types.int;
        default = 1800;
        description = "Refresh interval in seconds.";
      };
    };

    config = lib.mkIf (cfg.enable && cfg.modules.weather.enable) {
      programs.goather.enable = true;

      programs.waybar.settings.mainBar."custom/weather" = {
        exec = lib.getExe config.programs.goather.package;
        return-type = "json";
        inherit (cfg.modules.weather) format interval;
        tooltip = true;
      };
    };
  };
}
