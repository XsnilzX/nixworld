_: {
  flake.homeModules.dev-vscode = {
    config,
    lib,
    nixpkgsChannel,
    pkgs,
    ...
  }: let
    isStable = nixpkgsChannel == "stable";
    profileNames = [
      "C-C++"
      "Go"
      "Java"
      "Nix-OS"
      "Python"
      "Rust"
      "Typst"
    ];

    profileFiles =
      lib.concatMap (profileName: [
        "${config.home.homeDirectory}/.config/VSCodium/User/profiles/${profileName}/extensions.json"
        "${config.home.homeDirectory}/.config/VSCodium/User/profiles/${profileName}/settings.json"
      ])
      profileNames;
    vscodiumMigration = lib.optionalAttrs (!isStable) {
      home.activation.prepareVscodiumExtensionLink = lib.hm.dag.entryBefore ["linkGeneration"] ''
        target="${config.home.homeDirectory}/.vscode-oss/extensions"
        if [ -d "$target" ] && [ ! -L "$target" ]; then
          run rm -rf "$target"
        fi
      '';

      home.file =
        lib.genAttrs (
          [
            ".vscode-oss/extensions"
            "${config.home.homeDirectory}/.config/VSCodium/User/settings.json"
          ]
          ++ profileFiles
        ) (_: {
          force = true;
        });
    };
    vscodeConfig = {
      enable = true;
      mutableExtensionsDir = false;
      profiles = {
        default = {
          extensions = with pkgs.vscode-extensions;
            [
              pkief.material-icon-theme
              # editorconfig.editorconfig
              esbenp.prettier-vscode
              # llvm-vs-code-extensions.vscode-clangd
              # rust-lang.rust-analyzer
              # ms-python.python
              continue.continue
              tomoki1207.pdf
              jnoortheen.nix-ide
              #redhat.java
            ]
            ++ (with pkgs.vscode-marketplace; [
              # Extensions, die nicht in den offiziellen pkgs sind, kommen hier rein:
            ]);

          # Extensions aktivieren
          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
            "git.autofetch" = true;
            "git.confirmSync" = false;
            "window.newWindowProfile" = "Default";
          };
        };
        "Python" = {
          extensions = with pkgs.vscode-extensions;
            [
              pkief.material-icon-theme
              esbenp.prettier-vscode
              ms-python.python
              continue.continue
              tomoki1207.pdf
            ]
            ++ (with pkgs.vscode-marketplace; [
              # Extensions, die nicht in den offiziellen pkgs sind, kommen hier rein:
              the0807.uv-toolkit
            ]);
          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "git.autofetch" = true;
            "git.confirmSync" = false;
          };
        };
        "Nix-OS" = {
          extensions = with pkgs.vscode-extensions;
            [
              pkief.material-icon-theme
              # editorconfig.editorconfig
              esbenp.prettier-vscode
              continue.continue
              tomoki1207.pdf
              jnoortheen.nix-ide
              signageos.signageos-vscode-sops
            ]
            ++ (with pkgs.vscode-marketplace; [
              # Extensions, die nicht in den offiziellen pkgs sind, kommen hier rein:
            ]);

          # Extensions aktivieren
          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "nix.formatterPath" = "${pkgs.alejandra}/bin/alejandra";
            "git.autofetch" = true;
            "git.confirmSync" = false;
          };
        };

        "Java" = {
          extensions = with pkgs.vscode-extensions;
            [
              pkief.material-icon-theme
              esbenp.prettier-vscode
              continue.continue
              tomoki1207.pdf
              redhat.java
            ]
            ++ (with pkgs.vscode-marketplace; [
              # Extensions, die nicht in den offiziellen pkgs sind, kommen hier rein:
            ]);

          # Extensions aktivieren
          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = false;
            "redhat.telemetry.enabled" = false;
            "git.autofetch" = true;
            "git.confirmSync" = false;
          };
        };

        "Typst" = {
          extensions = with pkgs.vscode-extensions; [
            pkief.material-icon-theme
            esbenp.prettier-vscode
            continue.continue
            tomoki1207.pdf
            myriad-dreamin.tinymist
          ];

          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "git.autofetch" = true;
            "git.confirmSync" = false;
          };
        };

        "Rust" = {
          extensions = with pkgs.vscode-extensions; [
            pkief.material-icon-theme
            continue.continue
            tomoki1207.pdf
            # Rust stuff
            rust-lang.rust-analyzer
            fill-labs.dependi
            tamasfe.even-better-toml
            nefrob.vscode-just-syntax
          ];

          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "git.autofetch" = true;
            "git.confirmSync" = false;
            "telemetry.telemetryLevel" = "off";
          };
        };

        "Go" = {
          extensions = with pkgs.vscode-extensions; [
            pkief.material-icon-theme
            esbenp.prettier-vscode
            continue.continue
            golang.go
            usernamehw.errorlens
          ];

          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "git.autofetch" = true;
            "git.confirmSync" = false;
            "go.useLanguageServer" = true;
            "go.lintTool" = "golangci-lint";
            "go.formatTool" = "goimports";
            "gopls" = {
              "ui.semanticTokens" = true;
              "formatting.gofumpt" = true;
            };
          };
        };

        "C-C++" = {
          extensions = with pkgs.vscode-extensions; [
            pkief.material-icon-theme
            esbenp.prettier-vscode
            llvm-vs-code-extensions.vscode-clangd
          ];

          userSettings = {
            "workbench.iconTheme" = "material-icon-theme";
            "editor.formatOnSave" = true;
            "git.autofetch" = true;
            "git.confirmSync" = false;
          };
        };
      };
    };
  in
    vscodiumMigration
    // {
      programs =
        if isStable
        then {
          vscode =
            vscodeConfig
            // {
              package = pkgs.vscodium;
            };
        }
        else {
          vscodium = vscodeConfig;
        };
    };
}
