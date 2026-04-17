{
  config,
  pkgs,
  username ? "xsnilzx",
  ...
}: {
  sops.secrets."users/${username}/passwordHash" = {
    sopsFile = ../../secrets/users + "/${username}.yaml";
    neededForUsers = true;
  };

  users.mutableUsers = false;

  users.users.${username} = {
    isNormalUser = true;
    description = "Primary user";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets."users/${username}/passwordHash".path;
  };

  programs.zsh.enable = true;

  home-manager.users.${username} = import ./home.nix;
}
