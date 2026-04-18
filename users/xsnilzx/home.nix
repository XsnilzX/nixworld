{
  hostname,
  lib,
  username ? "xsnilzx",
  ...
}: {
  imports =
    [
      ../../profiles/home/base.nix
      ../../profiles/home/dev.nix
    ]
    ++ lib.optionals (hostname == "nixspo") [
      ../../profiles/home/niri.nix
    ]
    ++ lib.optionals (hostname != "server-01" && hostname != "nixspo") [
      ../../profiles/home/desktop.nix
    ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
}
