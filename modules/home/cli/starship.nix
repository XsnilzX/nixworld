{...}: {
  flake.homeModules.cli-starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        # Deaktiviere langsame Module, wenn es hakt:
        # aws.disabled = true;
        # gcloud.disabled = true;
      };
    };
  };
}
