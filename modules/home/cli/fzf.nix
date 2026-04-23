_: {
  flake.homeModules.cli-fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
