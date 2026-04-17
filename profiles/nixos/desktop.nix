{pkgs, ...}: let
  nixosModules = import ../../modules/nixos;
in {
  imports = [
    ./base.nix
    nixosModules.desktop.cachyosKernel
    nixosModules.desktop.kde
    nixosModules.desktop.pipewire
    nixosModules.desktop.steam
    nixosModules.hardware.bluetooth
  ];

  services.fstrim.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.partitionmanager
    easyeffects
  ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      font-awesome
      libertine
      corefonts
    ];
  };
}
