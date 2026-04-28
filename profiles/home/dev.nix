{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.cli-uv
    self.homeModules.dev-common
    self.homeModules.dev-direnv
    self.homeModules.dev-helix
    self.homeModules.dev-vscode
    self.homeModules.dev-zed
  ];

  home.packages = with pkgs; [
    tree
    devbox
  ];
}
