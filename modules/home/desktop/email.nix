{
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
}
