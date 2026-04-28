_: {
  flake.homeModules.desktop-wallpaperScript = {
    config,
    pkgs,
    ...
  }: let
    wallpaperScript = pkgs.writeShellScriptBin "random-wallpaper" ''
      #!/usr/bin/env bash
      set -euo pipefail

      WALLPAPER_DIR="${config.home.homeDirectory}/Bilder/Wallpaper"
      CACHE_DIR="$HOME/.cache/wallpaper-cycler"
      FILELIST="$CACHE_DIR/files"
      HASHFILE="$CACHE_DIR/hash"

      mkdir -p "$CACHE_DIR"

      if [ ! -d "$WALLPAPER_DIR" ]; then
        exit 0
      fi

      # ---- Hash berechnen (nur filenames + mtime) ----
      NEW_HASH=$(
        ${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \
          \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) \
          -printf "%p %T@\n" \
        | ${pkgs.coreutils}/bin/sort \
        | ${pkgs.coreutils}/bin/sha256sum \
        | ${pkgs.coreutils}/bin/cut -d' ' -f1
      )

      OLD_HASH=""
      [ -f "$HASHFILE" ] && OLD_HASH=$(cat "$HASHFILE")

      # ---- Cache nur neu bauen wenn nötig ----
      if [ "$NEW_HASH" != "$OLD_HASH" ]; then
        ${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \
          \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) \
          > "$FILELIST"
        echo "$NEW_HASH" > "$HASHFILE"
      fi

      if [ ! -s "$FILELIST" ]; then
        exit 0
      fi

      # ---- awww daemon starten falls nötig ----
      if ! pgrep -x awww-daemon > /dev/null; then
        ${pkgs.awww}/bin/awww-daemon >/dev/null 2>&1 &
        sleep 0.5
      fi

      # ---- Outputs holen ----
      OUTPUTS=$(${pkgs.niri}/bin/niri msg --json outputs | ${pkgs.jq}/bin/jq -r '.[].name')

      # ---- Pro Output zufälliges Wallpaper ----
      while read -r OUTPUT; do
        FILE=$(${pkgs.coreutils}/bin/shuf -n 1 "$FILELIST")

        ${pkgs.awww}/bin/awww img "$FILE" \
          --outputs "$OUTPUT" \
          --transition-type fade \
          --transition-duration 1.8 \
          --transition-fps 60
      done <<< "$OUTPUTS"
    '';
  in {
    home.packages = with pkgs; [
      awww
      jq
      wallpaperScript
    ];

    # --- Service ---
    systemd.user.services.random-wallpaper = {
      Unit = {
        Description = "Random Wallpaper (performance optimized)";
        After = ["graphical-session.target"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${wallpaperScript}/bin/random-wallpaper";
      };
    };

    # --- Timer (alle 10 Minuten) ---
    systemd.user.timers.random-wallpaper = {
      Unit = {
        Description = "Wallpaper rotation timer";
      };

      Timer = {
        OnBootSec = "30s";
        OnUnitActiveSec = "10m";
        Unit = "random-wallpaper.service";
      };

      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
