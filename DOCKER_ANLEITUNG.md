# IKT-Vorfall Dockerisierung

Diese Anleitung führt dich durch die Einrichtung der IKT-Vorfall-Anwendung mit Docker.

## Voraussetzungen

Stelle sicher, dass folgende Software installiert ist:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Git (optional)

## Einrichtung

### 1. Docker Desktop starten

Starte Docker Desktop auf deinem Computer. In Windows findest du es im Startmenü.

### 2. Überprüfen, ob Docker läuft

Öffne PowerShell und führe folgenden Befehl aus:

```powershell
docker --version
```

Du solltest eine Ausgabe wie diese sehen:
```
Docker version 28.1.1, build 4eba377
```

### 3. Container bauen und starten

Navigiere zum Projekt-Verzeichnis und führe folgende Befehle aus:

```powershell
cd "Pfad\zu\IKTMeldung"
docker-compose build
docker-compose up -d
```

#### Alternativ: Verwende die PowerShell-Hilfsskripte

Du kannst auch das mitgelieferte PowerShell-Skript verwenden:

```powershell
.\docker-manage.ps1
```

Wähle Option 1, um die Container zu starten.

### 4. Anwendung aufrufen

Öffne einen Browser und gehe zu:

```
http://localhost:8080
```

Die IKT-Vorfall-Anwendung sollte nun angezeigt werden.

## Container-Verwaltung

### Container stoppen

```powershell
docker-compose down
```

### Logs anzeigen

```powershell
docker-compose logs
```

### Container neu bauen

Wenn du Änderungen am Code vorgenommen hast:

```powershell
docker-compose build --no-cache
docker-compose up -d
```

## Struktur der Dockerisierung

- **Dockerfile**: Definiert das Image mit Nginx als Webserver
- **docker-compose.yml**: Orchestriert den Container-Dienst
- **nginx.conf**: Konfiguration des Nginx-Webservers
- **.dockerignore**: Dateien, die nicht ins Image kopiert werden sollen

## Fehlerbehebung

### Docker-Daemon läuft nicht

Symptom: `error during connect: in the default daemon configuration on Windows`

Lösung: Stelle sicher, dass Docker Desktop läuft. Öffne Docker Desktop und warte, bis der Docker-Engine-Status "Running" anzeigt.

### Port bereits in Verwendung

Symptom: `Error starting userland proxy: Bind for 0.0.0.0:8080: unexpected error Permission denied`

Lösung: Ändere den Port in der `docker-compose.yml`:
```yaml
ports:
  - "8081:80"  # Ändern von 8080 auf einen freien Port
```
