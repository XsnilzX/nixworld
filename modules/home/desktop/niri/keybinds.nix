_: {
  flake.homeModules.desktop-niri-keybinds = {
    config,
    niriApplications,
    pkgs,
    ...
  }: {
    programs.niri.settings.binds = with config.lib.niri.actions; let
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

      volume-up = spawn wpctl ["set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
      volume-down = spawn wpctl ["set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
      volume-mute = spawn wpctl ["set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      mic-mute = spawn wpctl ["set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      brightness-up = spawn brightnessctl ["s" "5%+"];
      brightness-down = spawn brightnessctl ["s" "5%-"];
    in {
      "Mod+q".action.spawn = niriApplications.terminal;
      "Mod+x".action = close-window;
      "Mod+m".action.quit.skip-confirmation = true;
      "Mod+e".action.spawn = niriApplications.fileManager;
      "Mod+v".action = toggle-window-floating;
      "Mod+Space".action.spawn = niriApplications.appLauncher;
      "Mod+b".action.spawn = niriApplications.browser;
      "Mod+t".action.spawn = niriApplications.mail;
      "Mod+c".action.spawn = niriApplications.code;
      "Mod+l".action.spawn = "wleave";
      "Mod+h".action = show-hotkey-overlay;

      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Down".action = focus-workspace-down;
      "Mod+Up".action = focus-workspace-up;

      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Right".action = move-column-right;
      "Mod+Shift+Down".action = move-column-to-workspace-down;
      "Mod+Shift+Up".action = move-column-to-workspace-up;

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+0".action.focus-workspace = 10;

      "Mod+Shift+1".action.move-window-to-workspace = 1;
      "Mod+Shift+2".action.move-window-to-workspace = 2;
      "Mod+Shift+3".action.move-window-to-workspace = 3;
      "Mod+Shift+4".action.move-window-to-workspace = 4;
      "Mod+Shift+5".action.move-window-to-workspace = 5;
      "Mod+Shift+6".action.move-window-to-workspace = 6;
      "Mod+Shift+7".action.move-window-to-workspace = 7;
      "Mod+Shift+8".action.move-window-to-workspace = 8;
      "Mod+Shift+9".action.move-window-to-workspace = 9;
      "Mod+Shift+0".action.move-window-to-workspace = 10;

      "Mod+WheelScrollDown".action = focus-workspace-down;
      "Mod+WheelScrollUp".action = focus-workspace-up;

      "XF86AudioRaiseVolume".action = volume-up;
      "XF86AudioLowerVolume".action = volume-down;
      "XF86AudioMute".action = volume-mute;
      "XF86AudioMicMute".action = mic-mute;
      "XF86MonBrightnessUp".action = brightness-up;
      "XF86MonBrightnessDown".action = brightness-down;

      "XF86AudioNext".action.spawn = ["playerctl" "next"];
      "XF86AudioPrev".action.spawn = ["playerctl" "previous"];
      "XF86AudioPause".action.spawn = ["playerctl" "pause"];
      "XF86AudioPlay".action.spawn = ["playerctl" "play"];

      "Mod+o".action = toggle-overview;
      "Mod+Home".action = focus-column-first;
      "Mod+End".action = focus-column-last;
      "Mod+Ctrl+Home".action = move-column-to-first;
      "Mod+Ctrl+End".action = move-column-to-last;
      "Mod+f".action = maximize-column;

      "Print".action.screenshot = {};
      "Ctrl+Print".action.screenshot-screen = {write-to-disk = true;};
      "Alt+Print".action.screenshot-window = {write-to-disk = true;};
    };
  };
}
