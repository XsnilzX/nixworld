# Uebersicht

## Ziel

Dieses Repository ist ein schlankes Grundgeruest fuer ein Multi-Host-NixOS-Setup mit Home Manager, `flake-parts`, Host-Auto-Discovery und vorbereiteter `sops-nix`-Integration.

## Struktur

- `hosts/`: duenne Host-Entry-Points mit Hostname, Host-Metadaten, Host-Secrets, Hardware und Profilen
- `modules/`: kleine wiederverwendbare NixOS- und Home-Manager-Module
- `profiles/`: einfache Kombinationen aus Modulen fuer Basis-, Desktop-, Laptop-, Server- und Dev-Setups
- `users/`: Benutzerdefinitionen und Home-Manager-Einstieg
- `secrets/`: verschluesselte SOPS-Dateien pro Host, gemeinsam und pro User
- `lib/`: `mkHost`- und Host-Discovery-Helper fuer Flake-Outputs

## Hinweise

- Die Dateien `hardware-configuration.nix`, `disko.nix`, `.sops.yaml` und alle Dateien unter `secrets/` enthalten Platzhalter.
- Hosts unter `hosts/` werden automatisch exportiert, wenn `default.nix` und `meta.nix` vorhanden sind.
- Das Setup bleibt absichtlich ohne App-Discovery oder Deploy-Frameworks gehalten.
