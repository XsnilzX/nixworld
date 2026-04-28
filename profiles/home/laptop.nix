{pkgs, ...}: {
  imports = [
    ./desktop.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    xarchiver
    pavucontrol
    networkmanagerapplet
    blueman

    # extra games
    lunar-client
    prismlauncher
  ];
}
