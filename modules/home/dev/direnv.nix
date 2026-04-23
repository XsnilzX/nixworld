_: {
  flake.homeModules.dev-direnv = _: {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
