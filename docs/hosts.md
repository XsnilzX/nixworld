# Hosts und Struktur

## SSH pro Host

- `hosts/<name>/ssh.nix` ist die zentrale Stelle fuer hostbezogene SSH-Konfiguration.
- Public Login-Keys kommen in `users.users.<name>.openssh.authorizedKeys.keys`.
- SSH-Keypaare liegen verschluesselt unter `ssh_keys.<keyname>.private` und `ssh_keys.<keyname>.public` in `secrets/<hostname>.yaml`.
- Alle Eintraege unter `ssh_keys` werden automatisch als `~/.ssh/<keyname>` und `~/.ssh/<keyname>.pub` materialisiert.
- SSH-Client-Ziele ueber `home-manager.users.<name>.programs.ssh.matchBlocks` bleiben separat und koennen pro Host manuell ergaenzt werden.

## Neuer Host

1. `hosts/<name>/` anlegen
2. `meta.nix` mit mindestens `system` und optional `username` und `nixpkgsChannel` anlegen
3. `hardware-configuration.nix` durch eine echte Datei aus `nixos-generate-config` ersetzen
4. `disko.nix` ergaenzen oder leer lassen, bis ein Disk-Layout benoetigt wird
5. Passendes Profil in `hosts/<name>/default.nix` importieren
6. `secrets/<name>.yaml` anlegen und in `.sops.yaml` aufnehmen
7. Kein Eintrag in `flake.nix` notwendig, Hosts werden automatisch erkannt

## Nixpkgs-Kanal pro Host

Hosts nutzen standardmaessig `unstable`. Ein Host kann in `hosts/<name>/meta.nix` auf den stable-Kanal wechseln:

```nix
{
  system = "x86_64-linux";
  username = "xsnilzx";
  nixpkgsChannel = "stable"; # oder "unstable"; default: "unstable"
}
```

- `nixpkgsChannel` wechselt den primaeren `pkgs`-Satz des Hosts.
- Erlaubte Werte sind `"stable"` und `"unstable"`.
- `system.stateVersion` und `home.stateVersion` bleiben davon unberuehrt.
- Es gibt absichtlich keinen zweiten Paketkanal fuer einzelne Pakete.
