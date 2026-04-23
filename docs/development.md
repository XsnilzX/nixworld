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
- `ci.yml`: baut auf Pushes nach `main` ausserdem die Hosts `homelab`, `nixhael` und `nixspo`
- `update-flake-lock.yml`: aktualisiert `flake.lock` woechentlich und kann manuell gestartet werden

Fuer den Build-Upload nach Cachix wird das Repository-Secret `CACHIX_AUTH_TOKEN` erwartet.
