{ ... }:
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      "system/example-token" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "shared/example-env" = {
        sopsFile = ../../secrets/common.yaml;
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };
  };
}
