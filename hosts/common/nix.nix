{inputs, ...}: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs."nix-cachyos-kernel".overlays.default
      (final: prev: {
        helium = inputs.helium.packages.${prev.stdenv.hostPlatform.system}.default;
      })
    ];
  };
}
