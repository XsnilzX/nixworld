{ inputs, self }:
{
  hostname,
  system ? "x86_64-linux",
  username ? "myuser",
  modules ? [ ],
  specialArgs ? { },
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs =
    {
      inherit inputs self hostname username;
    }
    // specialArgs;

  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    {
      nixpkgs.hostPlatform = system;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs self hostname username;
        };
      };
    }
  ] ++ modules;
}
