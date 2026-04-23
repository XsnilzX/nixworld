{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    weatherWidget
    xarchiver
    pavucontrol
    networkmanagerapplet
    blueman
  ];
}
