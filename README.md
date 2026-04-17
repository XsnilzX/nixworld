# Multi-Host NixOS Flake

Dieses Repository ist ein bewusst schlankes Grundgeruest fuer ein Multi-Host-NixOS-Setup mit Home Manager und vorbereiteter `sops-nix`-Integration.

## Struktur

- `hosts/`: duenne Host-Entry-Points mit Hostname, Host-Secrets, Hardware und Profilen
- `modules/`: kleine wiederverwendbare NixOS- und Home-Manager-Module
- `profiles/`: einfache Kombinationen aus Modulen fuer Basis-, Desktop-, Laptop-, Server- und Dev-Setups
- `users/`: Benutzerdefinitionen und Home-Manager-Einstieg
- `secrets/`: verschluesselte SOPS-Dateien pro Host, gemeinsam und pro User
- `lib/`: kleiner `mkHost`-Helper fuer `lib.nixosSystem`

## Neuer Host

1. `hosts/<name>/` anlegen
2. `hardware-configuration.nix` durch eine echte Datei aus `nixos-generate-config` ersetzen
3. `disko.nix` ergaenzen oder leer lassen, bis ein Disk-Layout benoetigt wird
4. passendes Profil in `hosts/<name>/default.nix` importieren
5. `secrets/<name>.yaml` anlegen und in `.sops.yaml` aufnehmen
6. Host in `flake.nix` unter `nixosConfigurations` eintragen

## Secrets

- `.sops.yaml` enthaelt nur Platzhalter fuer Age-Recipients und muss vor dem ersten Einsatz angepasst werden.
- `secrets/*.yaml` sind bewusst als Platzhalter markiert. Vor einem echten Deploy muessen sie mit `sops` neu erstellt oder ersetzt werden.
- `hosts/common/sops.nix` zeigt ein gemeinsames Secret und ein host-spezifisches Secret, aber keine echten Werte.

## Hinweise

- Die Dateien `hardware-configuration.nix`, `disko.nix`, `.sops.yaml` und alle Dateien unter `secrets/` enthalten Platzhalter.
- Das Setup ist absichtlich ohne Auto-Discovery, `flake-parts` oder Deploy-Frameworks gehalten.
