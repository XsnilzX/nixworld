{
  hostname,
  lib,
  ...
}: let
  hostSopsFile = ../../secrets + "/${hostname}.yaml";
in {
  sops =
    {
      age.keyFile = "/var/lib/sops-nix/key.txt";
    }
    // lib.optionalAttrs (builtins.pathExists hostSopsFile) {
      defaultSopsFile = hostSopsFile;
    };
}
