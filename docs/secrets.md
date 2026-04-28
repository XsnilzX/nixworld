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
- Fuer `homelab` wird zusaetzlich der private Harmonia-Signierschluessel aus `secrets/homelab.yaml` genutzt.

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
harmonia:
  sign_key: cache.oelfatzen.de-1:...
```

- `ssh_keys` folgt weiter dem bestehenden Host-SSH-Schema und wird von `mkHostSshSecrets` ausgewertet.
- `hetzner_dns.env` wird als Environment-File fuer den Hetzner-DNS-Updater materialisiert.
- `crowdsec.caddy_api_key` wird in ein Caddy-Environment-File templated.
- `n8n.encryption_key` ist der rohe n8n-Encryption-Key.
- `n8n.db_password` ist das rohe PostgreSQL-Passwort fuer den n8n-User.
- `harmonia.sign_key` ist der private Binary-Cache-Schluessel fuer `cache.oelfatzen.de`.
- Der Public Key gehoert nicht in SOPS, sondern spaeter in `nix.settings.trusted-public-keys` der Clients.

### Harmonia-Schluessel erzeugen

Private und Public Key einmalig auf einer vertrauenswuerdigen Maschine erzeugen:

```bash
nix-store --generate-binary-cache-key \
  cache.oelfatzen.de-1 \
  ./cache.oelfatzen.de-1.secret \
  ./cache.oelfatzen.de-1.pub
```

Danach:

1. Den Inhalt von `./cache.oelfatzen.de-1.secret` als Klartextwert unter `harmonia.sign_key` in `secrets/homelab.yaml` eintragen.
2. Den Inhalt von `./cache.oelfatzen.de-1.pub` ausserhalb von SOPS aufbewahren.
3. Den Public Key spaeter auf Clients unter `nix.settings.trusted-public-keys` eintragen.
4. Den Cache auf Clients unter `nix.settings.substituters = [ "https://cache.oelfatzen.de" ];` ergaenzen.

Beispiel fuer die Client-Seite:

```nix
{
  nix.settings = {
    substituters = [
      "https://cache.oelfatzen.de"
    ];

    trusted-public-keys = [
      "cache.oelfatzen.de-1:bUoU97SJt0e2x0192VQf+c1xCyTjfxZ3Jgqqj4iYKSo="
    ];
  };
}
```

### ZFS-Dataset fuer Harmonia anlegen

Wenn Harmonia die Artefakte wirklich von `Big-Data` servieren soll, muss das Dataset auf den alternativen Store-Pfad gemountet werden, also auf `/Big-Data/nix/store`.

```bash
sudo zfs create \
  -o mountpoint=/Big-Data/nix/store \
  -o compression=zstd \
  -o atime=off \
  -o xattr=sa \
  -o acltype=posixacl \
  -o relatime=on \
  -o recordsize=128K \
  Big-Data/nix-cache
```

Danach den alternativen Store-Wurzelpfad anlegen, falls noetig:

```bash
sudo mkdir -p /Big-Data/nix
```

Hinweise zu den Optionen:

- `compression=zstd`: spart Platz ohne grossen CPU-Overhead.
- `atime=off`: vermeidet unnoetige Schreiblast durch Zugriffszeiten.
- `xattr=sa`: legt Extended Attributes effizienter ab.
- `acltype=posixacl`: passt zu Linux-ACLs.
- `recordsize=128K`: ein vernuenftiger Allround-Wert fuer groessere Artefakte.
- `mountpoint=/Big-Data/nix/store`: passt zur aktuellen Host-Konfiguration und zu `services.harmonia.settings.real_nix_store`.

Danach muss der alternative Store auch befuellt werden. Harmonia serviert nicht automatisch `/mnt/BigData/nix/store`, nur weil das Dataset existiert.

Ein einzelner Pfad laesst sich zum Beispiel so hinein kopieren:

```bash
sudo nix copy --to /Big-Data <store-path>
```

Mehrere Build-Ergebnisse kannst du genauso mit `nix copy --to /mnt/BigData` oder ueber einen separaten Build-Workflow dorthin schreiben. Wichtig ist, dass unter `/mnt/BigData/nix/store` echte Nix-Store-Pfade landen.

Im Repo gibt es dafuer auch einen kleinen Helfer:

```bash
scripts/copy-to-bigdata-store.sh .#nixosConfigurations.homelab.config.system.build.toplevel
```

Weitere Beispiele:

```bash
scripts/copy-to-bigdata-store.sh .#packages.x86_64-linux.hello
scripts/copy-to-bigdata-store.sh \
  .#nixosConfigurations.homelab.config.system.build.toplevel \
  .#packages.x86_64-linux.hello
```

Der Wrapper nutzt intern `sudo nix copy --to /mnt/BigData ...`. Falls dein alternativer Store auf einem anderen Pool liegt, kannst du das Ziel mit `STORE_ROOT=/anderer/pfad` ueberschreiben.

Falls du das Dataset auch per Sanoid sichern willst, ergaenze zusaetzlich einen passenden Eintrag in `services.zfsBackup.sanoidDatasets`, zum Beispiel fuer `Big-Data/nix/store`.

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
