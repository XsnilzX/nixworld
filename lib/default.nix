{
  inputs,
  self,
}: let
  nixpkgsLib = inputs.nixpkgs-unstable.lib;
  mkHost = import ./mkHost.nix {inherit inputs self;};
  discoverHostSshKeys = import ./discoverHostSshKeys.nix {lib = nixpkgsLib;};
in {
  inherit mkHost;
  discoverHosts = import ./discoverHosts.nix {inherit mkHost;};
  inherit discoverHostSshKeys;
  mkHostSshSecrets = import ./mkHostSshSecrets.nix {
    lib = nixpkgsLib;
    inherit discoverHostSshKeys;
  };
}
