_: {
  flake.homeModules.dev-common = {pkgs, ...}: {
    home.packages = with pkgs; [
      # nix ide
      alejandra
      nixd
      age
      sops

      # Coding
      uv
      stdenv.cc.cc.lib
      python313
    ];
  };
}
