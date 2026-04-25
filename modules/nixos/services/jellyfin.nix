_: {
  flake.nixosModules.services-jellyfin = {
    config,
    lib,
    pkgs,
    hostname,
    domain ? null,
    ...
  }: {
    config = lib.mkIf config.services.jellyfin.enable {
      users.users.jellyfin.extraGroups = [
        "video"
        "render"
        "multimedia"
      ];

      hardware.graphics = lib.mkIf (hostname == "homelab") {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          libva-vdpau-driver
        ];
      };

      services.jellyfin = {
        openFirewall = false;
        dataDir = "/services/jellyfin/config";
        cacheDir = "/services/jellyfin/cache";
      };

      systemd.services.jellyfin = {
        after = ["zfs-mount.service"];
        requires = ["zfs-mount.service"];
        environment = lib.mkIf (domain != null) {
          JELLYFIN_PublishedServerUrl = "https://jellyfin.${domain}";
        };
      };

      systemd.tmpfiles.rules = [
        "d /services/jellyfin 0750 jellyfin jellyfin -"
        "d /services/jellyfin/config 0750 jellyfin jellyfin -"
        "d /services/jellyfin/cache 0750 jellyfin jellyfin -"
      ];
    };
  };
}
