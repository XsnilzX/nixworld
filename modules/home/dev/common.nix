_: {
  flake.homeModules.dev-common = {pkgs, ...}: {
    home.packages = with pkgs; [
      # nix ide
      alejandra
      nixd
      age
      sops

      stdenv.cc.cc.lib
      python313
    ];
  };
}
