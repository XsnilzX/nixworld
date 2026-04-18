{
  inputs,
  self,
}:
let
  mkHost = import ./mkHost.nix { inherit inputs self; };
in {
  inherit mkHost;
  discoverHosts = import ./discoverHosts.nix { inherit mkHost; };
}
