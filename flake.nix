{
  description = "My own Nixworld systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

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

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    let
      localLib = import ./lib {
        inherit inputs self;
      };
    in
      flake-parts.lib.mkFlake { inherit inputs; } {
        systems = [ "x86_64-linux" ];

        flake = {
          lib = localLib;
          nixosConfigurations = localLib.discoverHosts {
            hostsDir = ./hosts;
          };
        };

        perSystem = { pkgs, ... }: {
          devShells.repo = pkgs.mkShell {
            packages = with pkgs; [
              age
              alejandra
              deadnix
              git
              jq
              nh
              nix
              sops
              ssh-to-age
              statix
            ];
          };
        };
      };
}
