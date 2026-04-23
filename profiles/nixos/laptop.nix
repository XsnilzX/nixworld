_: {
  imports = [
    ./desktop-common.nix
  ];
  services = {
    blueman.enable = true;
    udisks2.enable = true;
    openssh.enable = true;
    upower.enable = true;
  };
}
