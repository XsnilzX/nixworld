{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";

    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 1.0;
    };

    cursor = {
      package = pkgs.catppuccin-cursors.frappeDark;
      name = "capitaine-cursors";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 10;
        popups = 10;
      };
    };
  };
}
