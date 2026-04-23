{...}: {
  flake.nixosModules.services-docker = {
    virtualisation.docker.enable = true;
  };
}
