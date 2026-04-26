{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.dev-common
    self.homeModules.dev-direnv
  ];

  home.packages = with pkgs; [
    alejandra
    nixd
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
          name = "nix";
          auto-format = true;
          language-servers = ["nixd"];
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
        }
      ];
      language-server = {
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
      };
    };
  };
}
