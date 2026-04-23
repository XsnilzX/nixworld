{...}: {
  flake.nixosModules.desktop-printing = {pkgs, ...}: {
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [
          brlaser # Open-Source Brother Treiber
          # oder:
          # brgenml1lpr
          # brgenml1cupswrapper
        ];
      };
      avahi = {
        enable = true;
        nssmdns = true;
      };
    };
  };
}
