{
  base = {
    locale = ./base/locale.nix;
    nixSettings = ./base/nix-settings.nix;
    openssh = ./base/openssh.nix;
    sudo = ./base/sudo.nix;
  };

  services = {
    tailscale = ./services/tailscale.nix;
    caddy = ./services/caddy.nix;
  };

  desktop = {
    cachyosKernel = {
      lib,
      pkgs,
      ...
    }: {
      boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels."linuxPackages-cachyos-latest";
    };
    kde = ./desktop/kde.nix;
    pipewire = ./desktop/pipewire.nix;
    steam = ./desktop/steam.nix;
  };

  hardware = {
    bluetooth = ./hardware/bluetooth.nix;
  };
}
