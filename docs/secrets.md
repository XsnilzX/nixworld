# Secrets

## Grundlagen

- `.sops.yaml` enthaelt nur Platzhalter fuer Age-Recipients und muss vor dem ersten Einsatz angepasst werden.
- `secrets/*.yaml` sind bewusst als Platzhalter markiert. Vor einem echten Deploy muessen sie mit `sops` neu erstellt oder ersetzt werden.
- `hosts/common/sops.nix` zeigt ein gemeinsames Secret und ein host-spezifisches Secret, aber keine echten Werte.

## Host-Secrets bearbeiten

- Host-spezifische Secrets liegen in `secrets/<hostname>.yaml`.
- Welches File geladen wird, ist in `hosts/common/sops.nix` verdrahtet.
- Bearbeitet wird es direkt mit `sops`, zum Beispiel `sops secrets/nixspo.yaml`.
- Fuer `nixspo` werden aktuell `eduroam` und `luh-vpn` genutzt.
- Fuer `nixhael` wird aktuell `luh-vpn` genutzt.
- Fuer `homelab` werden SSH-Keymaterial, Hetzner-DNS, CrowdSec und N8N aus `secrets/homelab.yaml` genutzt.

## Homelab

- `secrets/homelab.yaml` buendelt alle host-spezifischen `homelab`-Secrets.
- Die Datei enthaelt aktuell diese Schluessel:

```yaml
ssh_keys: {}
hetzner_dns:
  env: |
    API_TOKEN=...
    HZN_ZONE=oelfatzen.de
    HZN_NAME=@
    HZN_IPV6=1
crowdsec:
  caddy_api_key: ...
n8n:
  encryption_key: ...
  db_password: ...
```

- `ssh_keys` folgt weiter dem bestehenden Host-SSH-Schema und wird von `mkHostSshSecrets` ausgewertet.
- `hetzner_dns.env` wird als Environment-File fuer den Hetzner-DNS-Updater materialisiert.
- `crowdsec.caddy_api_key` wird in ein Caddy-Environment-File templated.
- `n8n.encryption_key` ist der rohe n8n-Encryption-Key.
- `n8n.db_password` ist das rohe PostgreSQL-Passwort fuer den n8n-User.

## Eduroam

- Das Secret heisst `eduroam-env`.
- Es wird als Environment-File gelesen und muss deshalb mehrere `KEY=VALUE`-Zeilen enthalten.
- Aktuell wird `eduroam` nur auf `nixspo` importiert, daher muss der Eintrag mindestens in `secrets/nixspo.yaml` vorhanden sein.

Beim Bearbeiten mit `sops secrets/nixspo.yaml` den Klartextwert so eintragen:

```yaml
eduroam-env: |
  EDUROAM_ID=dein_login@uni-hannover.de
  EDUROAM_ANON_ID=anonymous@uni-hannover.de
  EDUROAM_PW=dein_passwort
```

Bedeutung:

- `EDUROAM_ID`: dein eduroam-Login
- `EDUROAM_ANON_ID`: anonyme Kennung, falls von der Hochschule verlangt
- `EDUROAM_PW`: dein eduroam-Passwort

## LUH VPN

- `luh-vpn` nutzt zwei getrennte Secrets:
- `luh-vpn-env` fuer den Benutzernamen als Environment-File
- `luh-vpn-password` fuer das Passwort als einzelnes Secret
- Das Modul ist aktuell auf `nixspo` und `nixhael` aktiv, daher muessen die Eintraege in `secrets/nixspo.yaml` und `secrets/nixhael.yaml` vorhanden sein.

Beim Bearbeiten mit `sops secrets/<hostname>.yaml` die Klartextwerte so eintragen:

```yaml
luh-vpn-env: |
  LUH_VPN_USERNAME=dein_benutzername

luh-vpn-password: dein_passwort
```

Bedeutung:

- `LUH_VPN_USERNAME`: dein VPN-Benutzername
- `luh-vpn-password`: nur das Passwort, ohne `KEY=`-Praefix

## Praktischer Ablauf

1. Passende Host-Datei mit `sops secrets/<hostname>.yaml` oeffnen.
2. Die benoetigten Keys in Klartext eintragen oder aktualisieren.
3. Datei speichern und schliessen, `sops` verschluesselt sie automatisch wieder.
4. Danach das betroffene Host-System neu bauen, damit `sops-nix` die Werte unter `/run/secrets/` materialisiert.
