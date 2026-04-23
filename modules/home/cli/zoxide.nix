{...}: {
  flake.homeModules.cli-zoxide = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
  };
}
