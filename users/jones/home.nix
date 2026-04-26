{
  hostname,
  lib,
  pkgs,
  ...
}: {
  home = {
    username = "jones";
    homeDirectory = lib.mkForce (
      if hostname == "home34b"
      then "/mnt/BigData/data/homes/jones"
      else "/home/jones"
    );
    stateVersion = "25.11";
  };

  programs = {
    bash.enable = true;
    uv.enable = true;
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    fastfetch
    helix
  ];
}
