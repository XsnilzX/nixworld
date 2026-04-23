# Multi-Host NixOS Flake

Dieses Repository ist ein schlankes Multi-Host-NixOS-Setup mit Home Manager, `flake-parts`, Host-Auto-Discovery und vorbereiteter `sops-nix`-Integration.

## Doku

- [Docs Index](docs/README.md)
- [Uebersicht](docs/overview.md)
- [Entwicklung und Checks](docs/development.md)
- [Hosts und Struktur](docs/hosts.md)
- [Secrets](docs/secrets.md)

## Schnellstart

```bash
nix develop .#repo
```

Fuer lokale Checks und Git-Hooks siehe [docs/development.md](docs/development.md).
