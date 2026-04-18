{
  lib,
  discoverHostSshKeys,
}: {
  secretsFile,
  username,
  homeDirectory ? "/home/${username}",
  group ? "users",
  secretNamePrefix ? "ssh",
}: let
  keyNames = discoverHostSshKeys {inherit secretsFile;};

  mkSecret = keyName: type:
    lib.nameValuePair "${secretNamePrefix}-${keyName}-${type}" {
      key = "ssh_keys/${keyName}/${type}";
      path = "${homeDirectory}/.ssh/${keyName}" + lib.optionalString (type == "public") ".pub";
      owner = username;
      inherit group;
      mode =
        if type == "private"
        then "0600"
        else "0644";
    };
in
  builtins.listToAttrs (
    lib.concatMap (keyName: [
      (mkSecret keyName "private")
      (mkSecret keyName "public")
    ])
    keyNames
  )
