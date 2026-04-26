_: {
  flake.nixosModules.services-samba = {
    config,
    lib,
    ...
  }: let
    cfg = config.services.sambaShareStack;
  in {
    options.services.sambaShareStack.enable = lib.mkEnableOption "Samba homes and media shares";

    config = lib.mkIf cfg.enable {
      services.samba = {
        enable = true;
        openFirewall = true;
        settings = {
          global = {
            workgroup = "34b";
            "invalid users" = ["root"];
            security = "user";
            "server min protocol" = "SMB2";
            "map to guest" = "never";
          };
          homes = {
            comment = "Home Directories";
            browseable = "no";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0700";
            "directory mask" = "0700";
            "valid users" = "%S";
            path = "/mnt/BigData/data/homes/%S";
          };
          shared = {
            path = "/mnt/BigData/data/fileshare/share";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "@fileshare";
            "force group" = "fileshare";
            "create mask" = "0660";
            "directory mask" = "2770";
          };
          multimedia = {
            path = "/mnt/BigData/data/Multimedia";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "valid users" = "@multimedia";
            "force group" = "multimedia";
            "create mask" = "0660";
            "directory mask" = "2770";
          };
        };
      };
    };
  };
}
