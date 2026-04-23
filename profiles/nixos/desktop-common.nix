{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./base.nix
    self.nixosModules.desktop-cachyos-kernel
    self.nixosModules.desktop-pipewire
    self.nixosModules.desktop-steam
    self.nixosModules.hardware-bluetooth
  ];

  services = {
    fstrim.enable = true;
    power-profiles-daemon.enable = true;
  };

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
