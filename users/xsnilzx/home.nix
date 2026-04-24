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
      ../../profiles/home/nixspo.nix
      ../../profiles/home/niri.nix
      ../../profiles/home/laptop.nix
    ]
    ++ lib.optionals (hostname == "nixhael") [
      ../../profiles/home/desktop.nix
    ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
}
