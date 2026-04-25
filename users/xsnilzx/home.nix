{
  hostname,
  lib,
  pkgs,
  username ? "xsnilzx",
  ...
}: {
  imports =
    [
      ../../profiles/home/base.nix
      ../../profiles/home/dev.nix
    ]
    ++ lib.optionals (hostname == "nixspo") [
      ../../profiles/home/nixspo.nix
      ../../profiles/home/niri.nix
      ../../profiles/home/laptop.nix
    ]
    ++ lib.optionals (hostname == "nixhael") [
      ../../profiles/home/desktop.nix
    ]
    ++ lib.optionals (hostname == "homelab") [
      {
        home.packages = with pkgs; [
          nh
        ];

        programs.zsh.shellAliases = {
          dcd = "docker compose down";
          dcp = "docker compose pull";
          dcu = "docker compose up -d";
        };
      }
    ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
}
