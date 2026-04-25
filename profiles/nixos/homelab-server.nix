{
  pkgs,
  self,
  ...
}: {
  imports = [
    ./server.nix
    self.nixosModules.services-docker
    self.nixosModules.services-caddy
    self.nixosModules.services-crowdsec
    self.nixosModules.services-jellyfin
    self.nixosModules.services-n8n
    self.nixosModules.services-hetzner-dns-update
    self.nixosModules.services-backup-zfs
    self.nixosModules.services-zfs-extra
  ];

  environment.systemPackages = with pkgs; [
    age
    alejandra
    btop
    docker-compose
    helix
    sanoid
    sops
    tree
    zfs
  ];
}
