{
  config,
  lib,
  pkgs,
  username ? "xsnilzx",
  ...
}: let
  passwordHashFile = ../../secrets/users + "/${username}.yaml";
  hasPasswordHash = builtins.pathExists passwordHashFile;
in {
  sops.secrets = lib.optionalAttrs hasPasswordHash {
    passwordHash = {
      sopsFile = passwordHashFile;
      neededForUsers = true;
    };
  };

  users.mutableUsers = !hasPasswordHash;

  users.users.${username} =
    {
      isNormalUser = true;
      description = "Primary user";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
    }
    // lib.optionalAttrs hasPasswordHash {
      hashedPasswordFile = config.sops.secrets.passwordHash.path;
    };

  programs.zsh.enable = true;

  home-manager.users.${username} = import ./home.nix;
}
