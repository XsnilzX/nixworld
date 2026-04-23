{
  inputs,
  self,
}: {
  hostname,
  system ? "x86_64-linux",
  username ? "myuser",
  nixpkgsChannel ? "unstable",
  modules ? [],
  specialArgs ? {},
}: let
  validNixpkgsChannels = [
    "stable"
    "unstable"
  ];

  selectedNixpkgs =
    if nixpkgsChannel == "stable"
    then inputs.nixpkgs-stable
    else inputs.nixpkgs-unstable;

  selectedHomeManager =
    if nixpkgsChannel == "stable"
    then inputs.home-manager-stable
    else inputs.home-manager;
in
  if !(builtins.elem nixpkgsChannel validNixpkgsChannels)
  then builtins.throw "Unsupported nixpkgsChannel '${nixpkgsChannel}' for host '${hostname}'. Expected one of: stable, unstable."
  else
    selectedNixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs =
        {
          inherit inputs self hostname username nixpkgsChannel;
        }
        // specialArgs;

      modules =
        [
          selectedHomeManager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          {
            nixpkgs.hostPlatform = system;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs self hostname username nixpkgsChannel;
              };
            };
          }
        ]
        ++ modules;
    }
