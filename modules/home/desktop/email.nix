{...}: {
  flake.homeModules.desktop-email = {
    programs.thunderbird = {
      enable = true;

      profiles.default = {
        isDefault = true;
        # optional:
        settings = {
          "intl.locale.requested" = "de";
        };
      };
    };
  };
}
