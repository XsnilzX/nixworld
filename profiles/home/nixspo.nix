{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  weatherWidgetPath = "${config.home.homeDirectory}/Git/weather-widget";
  vscodiumProfileNames = ["default" "Python" "Nix-OS" "Java" "C-C++" "Typst" "Rust" "Go"];
  stylixVscodiumExtension =
    pkgs.runCommandLocal "stylix-vscodium"
    {
      vscodeExtUniqueId = "stylix.stylix";
      vscodeExtPublisher = "stylix";
      version = "0.0.0";
      theme = builtins.toJSON (import (inputs.stylix + "/modules/vscode/templates/theme.nix") config.lib.stylix.colors);
      passAsFile = ["theme"];
    }
    ''
      mkdir -p "$out/share/vscode/extensions/$vscodeExtUniqueId/themes"
      ln -s ${inputs.stylix + "/modules/vscode/package.json"} "$out/share/vscode/extensions/$vscodeExtUniqueId/package.json"
      cp "$themePath" "$out/share/vscode/extensions/$vscodeExtUniqueId/themes/stylix.json"
    '';
  stylixVscodiumSettings = import (inputs.stylix + "/modules/vscode/templates/settings.nix") config.stylix.fonts;
  weatherWidget = pkgs.writeShellScriptBin "weather-widget" ''
    export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
    ]}"

    if [ ! -d "${weatherWidgetPath}" ]; then
      echo "weather-widget repo not found at ${weatherWidgetPath}" >&2
      exit 1
    fi

    if [ ! -f "${weatherWidgetPath}/main.py" ]; then
      echo "weather-widget main.py not found at ${weatherWidgetPath}" >&2
      exit 1
    fi

    cd "${weatherWidgetPath}"
    exec ${pkgs.uv}/bin/uv run main.py "$@"
  '';
in {
  home = {
    sessionVariables = {
      SAL_USE_VCLPLUGIN = "gtk4";

      XCURSOR_SIZE = toString config.stylix.cursor.size;
      XCURSOR_THEME = config.stylix.cursor.name;
    };

    packages = [
      weatherWidget
      (pkgs.kdePackages.kcalc.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.makeWrapper];

        postFixup = ''
          wrapProgram $out/bin/kcalc \
            --unset QT_QPA_PLATFORMTHEME \
            --unset QT_STYLE_OVERRIDE \
            --unset QT_QUICK_CONTROLS_STYLE \
            --set QT_QPA_PLATFORM wayland
        '';
      }))
    ];
  };

  stylix = {
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    targets = {
      gtk.enable = true;
      firefox.profileNames = ["default"];
      vscode.enable = false;
      zen-browser.profileNames = ["default"];
      zed.enable = true;
    };
  };

  programs.vscodium.profiles = lib.genAttrs vscodiumProfileNames (_: {
    extensions = [stylixVscodiumExtension];
    userSettings = stylixVscodiumSettings;
  });

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
