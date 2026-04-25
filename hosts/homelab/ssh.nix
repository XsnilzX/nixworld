{
  hostname,
  self,
  username ? "xsnilzx",
  ...
}: let
  homeDirectory = "/home/${username}";
  sshPath = "${homeDirectory}/.ssh";
  secretsFile = ../../secrets + "/${hostname}.yaml";
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOVXo+rYVc9q+b3i+Tg2fwDiEOVKVdgg0u8IQL2KxE8"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKU6jZE2Awzx2RPM7YL4Dmc/i4/UXzX+Syo1t+FrF0QI richard@taesler.net"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKSa+GxhVFHnjEHm3A7XTZHADDUA8GundFu4Pqwagkqa xsnilzx@nixhael"
  ];
  matchBlocks = {};
in {
  users.users.${username}.openssh.authorizedKeys.keys = authorizedKeys;

  sops.secrets = self.lib.mkHostSshSecrets {
    inherit secretsFile username homeDirectory;
  };

  home-manager.users.${username} = {
    config,
    lib,
    ...
  }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      inherit matchBlocks;
    };

    home.activation.materializeSshConfig = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run mkdir -p ${lib.escapeShellArg sshPath}
      run chmod 700 ${lib.escapeShellArg sshPath}
      run rm -f ${lib.escapeShellArg "${sshPath}/config"}
      run install -m 600 \
        ${lib.escapeShellArg config.home.file.".ssh/config".source} \
        ${lib.escapeShellArg "${sshPath}/config"}
    '';
  };
}
