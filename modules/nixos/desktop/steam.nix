_: {
  flake.nixosModules.desktop-steam = {pkgs, ...}: {
    programs = {
      gamemode.enable = true;
      gamescope.enable = true;

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
  };
}
