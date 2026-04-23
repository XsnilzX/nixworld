_: {
  flake.homeModules.dev-vscode = {
    pkgs,
    lib,
    ...
  }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
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
  };
}
