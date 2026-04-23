{...}: {
  flake.nixosModules.desktop-mullvad-vpn = {
    mullvad-vpn.enable = true;
  };
}
