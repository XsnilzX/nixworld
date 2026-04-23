{
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.cli-git
    self.homeModules.cli-zsh
    self.homeModules.cli-starship
    self.homeModules.cli-zoxide
  ];

  home.packages = with pkgs; [
    zip
    unzip
    p7zip

    libnotify
    xdg-utils
    fastfetch
    ncdu
    fd
    ripgrep
    bat
  ];

  programs.home-manager.enable = true;
}
