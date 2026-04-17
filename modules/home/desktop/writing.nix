{pkgs, ...}: {
  home.packages = with pkgs; [
    zotero

    libreoffice-fresh
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    mythes
    hyphenDicts.de_DE
    hyphenDicts.en_US
  ];
}
