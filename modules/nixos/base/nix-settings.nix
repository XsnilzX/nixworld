_: {
  flake.nixosModules.base-nix-settings = {lib, ...}: {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        max-jobs = "auto";
        cores = 0;

        min-free = 128000000; # 128MB
        max-free = 1000000000; # 1GB

        download-buffer-size = 268435456; # 256 MiB

        keep-outputs = true;
        keep-derivations = true;

        fallback = true;

        auto-optimise-store = true;
        sandbox = true;

        builders-use-substitutes = true;
        warn-dirty = false;

        substituters = [
          "https://cache.garnix.io"
          "https://cache.nixos.org/"
          "https://xsnilzx.cachix.org"
        ];

        trusted-substituters = [
          "https://attic.xuyh0120.win/lantian"
          "https://cache.nixos.org/"
          "https://xsnilzx.cachix.org"
        ];

        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "xsnilzx.cachix.org-1:Sxn4bw0QwjTLqFcK5esmKsXR3NDPi1Wr2ZhOiGcJDjc="
        ];
      };

      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
      };
    };
  };
}
