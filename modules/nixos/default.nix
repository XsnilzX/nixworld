let
  uppercase = char:
    builtins.replaceStrings
      [
        "a"
        "b"
        "c"
        "d"
        "e"
        "f"
        "g"
        "h"
        "i"
        "j"
        "k"
        "l"
        "m"
        "n"
        "o"
        "p"
        "q"
        "r"
        "s"
        "t"
        "u"
        "v"
        "w"
        "x"
        "y"
        "z"
      ]
      [
        "A"
        "B"
        "C"
        "D"
        "E"
        "F"
        "G"
        "H"
        "I"
        "J"
        "K"
        "L"
        "M"
        "N"
        "O"
        "P"
        "Q"
        "R"
        "S"
        "T"
        "U"
        "V"
        "W"
        "X"
        "Y"
        "Z"
      ]
      char;

  upperFirst = value:
    if value == "" then
      ""
    else
      uppercase (builtins.substring 0 1 value)
      + builtins.substring 1 (builtins.stringLength value - 1) value;

  kebabToCamel = value:
    let
      match = builtins.match "([^-]+)-(.+)" value;
    in
      if match == null then
        value
      else
        builtins.elemAt match 0
        + upperFirst (kebabToCamel (builtins.elemAt match 1));

  moduleName = filename:
    kebabToCamel (builtins.substring 0 (builtins.stringLength filename - 4) filename);

  importModuleTree = dir:
    let
      dirEntries = builtins.readDir dir;
      names = builtins.attrNames dirEntries;
      visibleNames = builtins.filter (
        name:
        name != "default.nix"
        && (
          dirEntries.${name} == "directory"
          || (dirEntries.${name} == "regular" && builtins.match ".*\\.nix" name != null)
        )
      ) names;
    in
      builtins.listToAttrs (
        builtins.map (
          name:
          let
            entryType = dirEntries.${name};
          in
            if entryType == "directory" then
              {
                name = kebabToCamel name;
                value = importModuleTree (dir + "/${name}");
              }
            else
              {
                name = moduleName name;
                value = dir + "/${name}";
              }
        ) visibleNames
      );
in
  importModuleTree ./.
