{lib}: {
  secretsFile,
  rootKey ? "ssh_keys",
}: let
  lines =
    if builtins.pathExists secretsFile
    then lib.splitString "\n" (builtins.readFile secretsFile)
    else [];

  rootPattern = "^[[:space:]]*" + rootKey + ":[[:space:]]*$";
  topLevelPattern = "^[^[:space:]#][^:]*:[[:space:]]*(#.*)?$";
  nestedKeyPattern = "^[[:space:]]+([^:#][^:]*)[[:space:]]*:[[:space:]]*(#.*)?$";

  step = state: line:
    if state.inRoot
    then
      if builtins.match topLevelPattern line != null
      then state // {inRoot = false;}
      else let
        nestedMatch = builtins.match nestedKeyPattern line;
      in
        if nestedMatch == null
        then state
        else let
          name = builtins.elemAt nestedMatch 0;
        in
          if builtins.elem name ["private" "public"]
          then state
          else
            state
            // {
              names = state.names ++ [name];
            }
    else if builtins.match rootPattern line != null
    then state // {inRoot = true;}
    else state;

  result =
    builtins.foldl' step {
      inRoot = false;
      names = [];
    }
    lines;
in
  lib.unique result.names
