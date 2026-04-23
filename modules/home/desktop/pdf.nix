_: {
  flake.homeModules.desktop-pdf = {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        # === Anzeigeverhalten ===
        set adjust-open width
        set pages-per-row 1
        set scroll-step 100

        # === Dark Mode (Augenfreundlich) ===
        #set recolor true
        #set recolor-keephue true
        #set recolor-darkcolor "#1e1e2e"   # Hintergrund
        #set recolor-lightcolor "#cdd6f4"  # Text
        set default-bg "#1e1e2e"
        set default-fg "#cdd6f4"

        # === Interface ===
        set show-scrollbars false
        set statusbar-h-padding 5
        set statusbar-v-padding 2
        set font "sans 10"

        # === Steuerung: klassisch ===
        # Standardmäßig nutzt Zathura:
        # Pfeiltasten     → scrollen
        # PageUp/PageDown → seitenweise scrollen
        map <Left> scroll full-up
        map <Right> scroll full-down
        # Home/End        → Anfang / Ende
        # + / - / =       → Zoom in/out/fit
        # /               → Suche starten
        # n / N           → nächstes / vorheriges Suchergebnis

        # === Suche und Markierungen ===
        set incremental-search true
        set search-hilight-color "#fab387"
        set highlight-color "#a6e3a1"
        set highlight-active-color "#f9e2af"

        # === Sonstiges ===
        set selection-clipboard clipboard
        set database "sqlite"
        set zoom-center true
      '';
    };
  };
}
