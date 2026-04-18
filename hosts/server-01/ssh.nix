{
  hostname,
  self,
  username ? "xsnilzx",
  ...
}: let
  homeDirectory = "/home/${username}";
  sshPath = "${homeDirectory}/.ssh";
  secretsFile = ../../secrets + "/${hostname}.yaml";
  authorizedKeys = [];
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
