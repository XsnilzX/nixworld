_: {
  flake.homeModules.desktop-niri-applications = {
    config,
    lib,
    pkgs,
    ...
  }: {
    _module.args.niriApplications = {
      browser = lib.getExe pkgs.helium;
      terminal = lib.getExe config.programs.ghostty.package;
      fileManager = "thunar";
      appLauncher = "anyrun";
      mail = "thunderbird";
      code = lib.getExe config.programs.vscode.package;
    };
  };
}
