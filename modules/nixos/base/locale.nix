{...}: {
  flake.nixosModules.base-locale = {...}: {
    i18n.defaultLocale = "de_DE.UTF-8";
    time.timeZone = "Europe/Berlin";
    console.keyMap = "de";
  };
}
