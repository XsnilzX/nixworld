{
  cli = {
    eza = ./cli/eza.nix;
    fzf = ./cli/fzf.nix;
    git = ./cli/git.nix;
    starship = ./cli/starship.nix;
    zoxide = ./cli/zoxide.nix;
    zsh = ./cli/zsh.nix;
    uv = ./cli/uv.nix;
  };

  dev = {
    common = ./dev/common.nix;
    direnv = ./dev/direnv.nix;
    helix = ./dev/helix.nix;
    vscode = ./dev/vscode.nix;
    zed = ./dev/zed.nix;
  };

  desktop = {
    audio = ./desktop/audio.nix;
    email = ./desktop/email.nix;
    ghostty = ./desktop/ghostty.nix;
    images = ./desktop/images.nix;
    pdf = ./desktop/pdf.nix;
    recording = ./desktop/recording.nix;
    video = ./desktop/video.nix;
    waybar = ./desktop/waybar.nix;
    writing = ./desktop/writing.nix;
  };
}
