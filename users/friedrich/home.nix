{pkgs, ...}: {
  home = {
    username = "friedrich";
    homeDirectory = "/home/friedrich";
    stateVersion = "25.11";
  };

  programs = {
    bash.enable = true;
    uv.enable = true;

    eza = {
      enable = true;
      enableBashIntegration = true;
      icons = "auto";
      git = true;
      extraOptions = ["--group-directories-first" "--header"];
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      options = ["--cmd cd"];
    };

    git = {
      enable = true;
      settings.user = {
        name = "YOUR NAME";
        email = "YOUR@MAIL";
      };
    };

    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    fastfetch
    nano
  ];
}
