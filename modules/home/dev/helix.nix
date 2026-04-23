{...}: {
  flake.homeModules.dev-helix = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      # Für C/C++
      clang-tools
      gcc
      # Rust (cargo ist meistens via rustup oder rustc da, aber rust-analyzer wird gebraucht)
      rust-analyzer
      # Go
      gopls
      gotools # für gofumpt/goimports
      # Typst
      tinymist
      # Java
      jdt-language-server
    ];

    programs.helix = {
      enable = true;
      settings = {
        theme = lib.mkForce "dracula_at_night";
        editor = {
          scrolloff = 8;
          scroll-lines = 4;
          line-number = "relative";
          auto-format = false;
        };
        editor.statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
          diagnostics = ["warning" "error"];
          workspace-diagnostics = ["warning" "error"];
        };
        editor.lsp = {
          display-messages = true;
        };
      };
      languages = {
        language = [
          {
            name = "c";
            auto-format = true;
            language-servers = ["clangd"];
          }
          {
            name = "cpp";
            auto-format = true;
            language-servers = ["clangd"];
          }
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "typst";
            language-servers = ["tinymist"];
          }
          {
            name = "go";
            language-servers = ["gopls"];
          }
          {
            name = "java";
            language-servers = ["jdtls"];
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = ["nixd"];
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
            };
          }
        ];
        language-server = {
          clangd = {
            command = "clangd";
            # Nützliche Argumente für clangd
            args = [
              "--background-index"
              "--clang-tidy"
              "--header-insertion=iwyu"
              "--completion-style=detailed"
              "--function-arg-placeholders"
              "--fallback-style=llvm"
            ];
          };
          gopls = {
            command = "gopls";
            args = ["-logfile=/tmp/gopls.log" "serve"];
            config = {
              "ui.diagnostic.staticcheck" = false;
              gofumpt = true;
            };
          };
          jdtls = {
            command = "jdtls";
          };
          rust-analyzer = {
            command = "rust-analyzer";
          };
          tinymist = {
            command = "${pkgs.tinymist}/bin/tinymist";
          };
          nixd = {
            command = "${pkgs.nixd}/bin/nixd";
          };
        };
      };
    };
  };
}
