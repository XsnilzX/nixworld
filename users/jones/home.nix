{pkgs, ...}: {
  home = {
    username = "jones";
    homeDirectory = "/home/jones";
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
