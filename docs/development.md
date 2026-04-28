# Entwicklung und Checks

## Dev Shell

- `nix develop .#repo` startet die zentrale Shell fuer Arbeiten an diesem Repository.
- Die Shell enthaelt Repo-Werkzeuge wie `nix`, `git`, `pre-commit`, `alejandra`, `statix`, `deadnix`, `sops` und `age`.

## Pre-Commit

Die Hook-Konfiguration liegt in [../.pre-commit-config.yaml](../.pre-commit-config.yaml).

Aktive lokale Hooks:

- `nix flake check` auf `pre-push`
- `alejandra --check .` auf `pre-commit` und `pre-push`
- `statix check .` auf `pre-commit` und `pre-push`
- `deadnix .` auf `pre-commit` und `pre-push`

## Hooks installieren

```bash
nix develop .#repo
pre-commit install --hook-type pre-commit --hook-type pre-push
```

## Hooks manuell ausfuehren

```bash
pre-commit run --all-files
pre-commit run --hook-stage pre-push --all-files
```

## Direkte Checks

```bash
alejandra --check .
statix check .
deadnix .
nix flake check
```

## GitHub Actions

Die GitHub-Workflows liegen unter [../.github/workflows](../.github/workflows):

- `ci.yml`: fuehrt `nix flake check`, `alejandra`, `statix` und `deadnix` auf Push und Pull Requests aus
- `ci.yml`: baut auf Pushes nach `main` ausserdem die Hosts `homelab`, `nixhael` und `nixspo`; `homelab` haengt dabei nun am Profil `profiles/nixos/homelab-server.nix`
- `update-flake-lock.yml`: laeuft technisch auf `main`, checkt `dev` aus, aktualisiert dort `flake.lock` und erstellt einen PR nach `main`
- `update-flake-lock.yml`: aktiviert fuer den erzeugten PR Merge-Auto-Merge, damit der resultierende `main`-Commit anschliessend per Fast-Forward nach `dev` gespiegelt werden kann
- `update-flake-lock.yml`: laeuft auf Pushes nach `main` zusaetzlich als Sync-Job und zieht `dev` per Fast-Forward auf denselben Commit-Stand nach, solange `dev` nicht unabhaengig divergiert ist

Fuer den Build-Upload nach Cachix wird das Repository-Secret `CACHIX_AUTH_TOKEN` erwartet.
Fuer den automatischen Merge muss im GitHub-Repository ausserdem `Allow auto-merge` aktiviert sein.
