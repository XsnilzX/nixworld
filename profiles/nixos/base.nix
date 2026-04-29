{
  pkgs,
  client ? "server",
  lib,
  self,
  ...
}: {
  imports =
    [
      self.nixosModules.base-graphics
      self.nixosModules.base-locale
      self.nixosModules.base-nix-settings
      self.nixosModules.base-openssh
      self.nixosModules.base-sudo
    ]
    ++ lib.optionals (client == "pc") [
      self.nixosModules.base-plymouth
    ];

  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
  system.stateVersion = "25.05";

  environment.systemPackages = with pkgs; [
    vim
    wget
    nh
    exfatprogs
    wireguard-tools
  ];
}
