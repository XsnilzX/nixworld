{pkgs, ...}: {
  home.packages = with pkgs; [
    # audio
    pavucontrol
  ];

  services.playerctld.enable = true;
}
