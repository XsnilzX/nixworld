# Multi-Host NixOS Flake

Dieses Repository ist ein bewusst schlankes Grundgeruest fuer ein Multi-Host-NixOS-Setup mit Home Manager, `flake-parts`, Host-Auto-Discovery und vorbereiteter `sops-nix`-Integration.

## Struktur

- `hosts/`: duenne Host-Entry-Points mit Hostname, Host-Metadaten, Host-Secrets, Hardware und Profilen
- `modules/`: kleine wiederverwendbare NixOS- und Home-Manager-Module
- `profiles/`: einfache Kombinationen aus Modulen fuer Basis-, Desktop-, Laptop-, Server- und Dev-Setups
- `users/`: Benutzerdefinitionen und Home-Manager-Einstieg
- `secrets/`: verschluesselte SOPS-Dateien pro Host, gemeinsam und pro User
- `lib/`: `mkHost`- und Host-Discovery-Helper fuer Flake-Outputs

## Neuer Host

1. `hosts/<name>/` anlegen
2. `meta.nix` mit mindestens `system` und optional `username` anlegen
3. `hardware-configuration.nix` durch eine echte Datei aus `nixos-generate-config` ersetzen
4. `disko.nix` ergaenzen oder leer lassen, bis ein Disk-Layout benoetigt wird
5. passendes Profil in `hosts/<name>/default.nix` importieren
6. `secrets/<name>.yaml` anlegen und in `.sops.yaml` aufnehmen
7. Kein Eintrag in `flake.nix` notwendig, Hosts werden automatisch erkannt

## Dev Shell

- `nix develop .#repo` startet die zentrale Shell fuer Arbeiten an diesem Repository.
- Die Shell enthaelt Nix- und Repo-Werkzeuge wie `alejandra`, `statix`, `deadnix`, `sops` und `age`.

## Secrets

- `.sops.yaml` enthaelt nur Platzhalter fuer Age-Recipients und muss vor dem ersten Einsatz angepasst werden.
- `secrets/*.yaml` sind bewusst als Platzhalter markiert. Vor einem echten Deploy muessen sie mit `sops` neu erstellt oder ersetzt werden.
- `hosts/common/sops.nix` zeigt ein gemeinsames Secret und ein host-spezifisches Secret, aber keine echten Werte.

## Hinweise

- Die Dateien `hardware-configuration.nix`, `disko.nix`, `.sops.yaml` und alle Dateien unter `secrets/` enthalten Platzhalter.
- Hosts unter `hosts/` werden automatisch exportiert, wenn `default.nix` und `meta.nix` vorhanden sind.
- Das Setup bleibt absichtlich ohne App-Discovery oder Deploy-Frameworks gehalten.
