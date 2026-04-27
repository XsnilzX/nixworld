{mkHost}: {hostsDir ? ../hosts}: let
  entries = builtins.readDir hostsDir;
  names = builtins.attrNames entries;

  discoverHost = name: let
    isDirectory = entries.${name} == "directory";
    hostPath = hostsDir + "/${name}";
    hostEntries =
      if isDirectory
      then builtins.readDir hostPath
      else {};
    hasDefault = builtins.hasAttr "default.nix" hostEntries;
    hasMeta = builtins.hasAttr "meta.nix" hostEntries;
  in
    if !isDirectory || name == "common"
    then null
    else if hasDefault && hasMeta
    then {
      inherit name hostPath;
      meta = import (hostPath + "/meta.nix");
    }
    else if hasDefault || hasMeta
    then builtins.throw "Host directory '${name}' must contain both default.nix and meta.nix."
    else null;

  hosts = builtins.filter (host: host != null) (builtins.map discoverHost names);

  mkHostConfig = host: let
    inherit (host) meta;
  in
    if !(meta ? system)
    then builtins.throw "Host metadata for '${host.name}' must define `system`."
    else {
      inherit (host) name;
      value = mkHost (
        {
          hostname = host.name;
          inherit (meta) system;
          modules = [host.hostPath];
        }
        // (
          if meta ? username
          then {inherit (meta) username;}
          else {}
        )
        // (
          if meta ? nixpkgsChannel
          then {inherit (meta) nixpkgsChannel;}
          else {}
        )
        // (
          if meta ? specialArgs
          then {inherit (meta) specialArgs;}
          else {}
        )
      );
    };
in
  builtins.listToAttrs (builtins.map mkHostConfig hosts)
