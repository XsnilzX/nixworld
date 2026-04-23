{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.cli-eza
    self.homeModules.cli-fzf
    self.homeModules.cli-git
    self.homeModules.cli-starship
    self.homeModules.cli-uv
    self.homeModules.cli-zoxide
    self.homeModules.cli-zsh
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
