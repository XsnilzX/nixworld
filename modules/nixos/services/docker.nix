_: {
  flake.nixosModules.services-docker = {
    config,
    lib,
    username,
    ...
  }: {
    options.services.docker.waitForZfs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Delay Docker startup until zfs-mount.service is active.";
    };

    config = {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        daemon.settings = {
          "storage-driver" = "overlay2";
        };
      };

      users.groups.docker.members = [username];

      systemd.services.docker = lib.mkIf config.services.docker.waitForZfs {
        after = ["zfs-mount.service"];
        requires = ["zfs-mount.service"];
      };
    };
  };
}
