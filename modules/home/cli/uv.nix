{...}: {
  flake.homeModules.cli-uv = {
    programs.uv.enable = true;
  };
}
