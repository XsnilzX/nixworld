{
  description = "My own Nixworld systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {...}: let
    localLib = import ./lib {inherit inputs;};
  in {
    lib = localLib;

    nixosConfigurations = {
      nixhael = localLib.mkHost {
        hostname = "nixhael";
        system = "x86_64-linux";
        modules = [./hosts/nixhael];
      };

      nixspo = localLib.mkHost {
        hostname = "nixspo";
        system = "x86_64-linux";
        modules = [./hosts/nixspo];
      };

      server-01 = localLib.mkHost {
        hostname = "server-01";
        system = "x86_64-linux";
        modules = [./hosts/server-01];
      };
    };
  };
}
