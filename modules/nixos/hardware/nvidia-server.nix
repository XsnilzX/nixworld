_: {
  flake.nixosModules.hardware-nvidia-server = {config, ...}: {
    hardware = {
      nvidia = {
        modesetting.enable = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      nvidia-container-toolkit = {
        enable = true;
        suppressNvidiaDriverAssertion = true;
      };
    };

    virtualisation.docker.enable = true;
  };
}
