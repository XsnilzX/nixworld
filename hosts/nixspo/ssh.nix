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
  matchBlocks = {
    "git-uni" = {
      hostname = "gitlab.uni-hannover.de";
      user = "git";
      identityFile = "${sshPath}/gitlab_unihannover";
      identitiesOnly = true;
    };
    "git-finf" = {
      hostname = "git.finf.uni-hannover.de";
      user = "git";
      identityFile = "${sshPath}/gitlab_finf";
      identitiesOnly = true;
    };
    "homelab" = {
      hostname = "10.0.20.10";
      user = "xsnilzx";
      identityFile = "${sshPath}/homelab";
      identitiesOnly = true;
    };
    "github" = {
      hostname = "github.com";
      user = "git";
      identityFile = "${sshPath}/github_key";
      identitiesOnly = true;
    };
    "home34b" = {
      hostname = "192.168.178.10";
      user = "richard";
      identityFile = "${sshPath}/home34b_key";
      identitiesOnly = true;
    };
    "biggi" = {
      hostname = "10.0.20.8";
      user = "richard";
      identityFile = "${sshPath}/biggi";
      identitiesOnly = true;
    };
    "huggingface" = {
      hostname = "hf.co";
      user = "git";
      identityFile = "${sshPath}/huggingface";
      identitiesOnly = true;
    };
    "lab" = {
      hostname = "lab.sra.uni-hannover.de";
      user = "ric.taesler";
      identityFile = "${sshPath}/lab";
      identitiesOnly = true;
    };
    "lab-pc" = {
      hostname = "lab-pc02";
      user = "ric.taesler";
      proxyJump = "lab";
    };
    "vbs" = {
      hostname = "praktifix";
      user = "user";
      port = 2212;
      proxyJump = "lab";
    };
    "krul" = {
      hostname = "krul.finf.uni-hannover.de";
      user = "xsnilzx";
      identityFile = "${sshPath}/krul";
    };
    "johndoe" = {
      hostname = "finf.uni-hannover.de";
      user = "Richard";
      identityFile = "${sshPath}/johndoe";
      identitiesOnly = true;
    };
  };
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

    home.file.".ssh/config".force = true;

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
