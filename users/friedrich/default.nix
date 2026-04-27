{pkgs, ...}: {
  users.users.friedrich = {
    isNormalUser = true;
    description = "Friedrich";
    extraGroups = [
      "wheel"
      "docker"
      "fileshare"
    ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYKUGYTdqrO6mxZUeAjOtYgCgJi7E8YVhIsSdnZBdBh friedrich-homeserver"
    ];
  };

  home-manager.users.friedrich = import ./home.nix;
}
