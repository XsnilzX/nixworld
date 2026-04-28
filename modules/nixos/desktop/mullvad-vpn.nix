_: {
  flake.nixosModules.desktop-mullvad-vpn = {
    lib,
    username,
    ...
  }: {
    services.mullvad-vpn.enable = true;

    home-manager.users.${username}.programs.mullvad-vpn.enable = lib.mkDefault true;
  };
}
