{...}: {
  flake.homeModules.dev-zed = {pkgs, ...}: {
    programs.zed-editor = {
      enable = true;
      extensions = ["nix" "typst" "java" "toml"];
      userSettings = {
        auto_update = false;

        assistant = {
          enabled = true;
          provider = "openai";
        };

        telemetry = {
          diagnostic = false;
          metrics = false;
        };

        format_on_save = true;
        git.auto_fetch = true;

        languages = {
          Java.lsp.command = "jdtls";

          JavaScript = {
            formatter = "prettier";
          };

          Nix = {
            formatter = {
              external = {
                command = "${pkgs.alejandra}/bin/alejandra";
                arguments = ["-"];
              };
            };
          };

          Python.formatter = "black";

          TypeScript = {
            formatter = "prettier";
          };
        };
      };
    };
  };
}
