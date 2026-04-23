_: {
  flake.homeModules.desktop-ghostty = {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Dracula";
        font-size = 12;
        font-family = "JetBrainsMono Nerd Font Mono";
        background-opacity = 0.6;
      };
    };
  };
}
