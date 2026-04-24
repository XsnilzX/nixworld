_: {
  flake.homeModules.desktop-niri-applications = {
    config,
    lib,
    ...
  }: {
    _module.args.niriApplications = {
      browser = lib.getExe config.programs.zen-browser.package;
      terminal = lib.getExe config.programs.ghostty.package;
      fileManager = "thunar";
      appLauncher = "anyrun";
      mail = "thunderbird";
      code = lib.getExe config.programs.vscode.package;
    };
  };
}
