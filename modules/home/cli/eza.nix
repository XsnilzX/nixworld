{...}: {
  flake.homeModules.cli-eza = {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = ["--group-directories-first" "--header"];
    };
  };
}
