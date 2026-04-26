{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.dev-common
    self.homeModules.dev-direnv
    self.homeModules.dev-helix
  ];
}
