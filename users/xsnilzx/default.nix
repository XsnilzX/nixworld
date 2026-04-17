{
  pkgs,
  username ? "xsnilzx",
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    description = "Primary user";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  home-manager.users.${username} = import ./home.nix;
}
