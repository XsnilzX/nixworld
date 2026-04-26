{pkgs, ...}: {
  users.users.jones = {
    isNormalUser = true;
    description = "Jones";
    extraGroups = [
      "wheel"
      "docker"
      "fileshare"
      "multimedia"
    ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [];
  };

  home-manager.users.jones = import ./home.nix;
}
