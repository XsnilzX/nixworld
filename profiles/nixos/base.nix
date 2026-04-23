{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.base-locale
    self.nixosModules.base-nix-settings
    self.nixosModules.base-openssh
    self.nixosModules.base-sudo
  ];

  networking.firewall.enable = true;
  system.stateVersion = "25.05";

  environment.systemPackages = with pkgs; [
    vim
    wget
    nh
    exfatprogs
    wireguard-tools
  ];
}
