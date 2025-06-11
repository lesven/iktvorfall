# IKT-Vorfall Docker Setup

Diese Anwendung hilft bei der Bewertung von IKT-Vorfällen gemäß DORA-Anforderungen.

## Docker-Installation

Die Anwendung kann mit Docker und Docker Compose einfach gestartet werden.

### Voraussetzungen

- Docker installiert
- Docker Compose installiert

### Container starten

1. In das Projektverzeichnis navigieren:
   ```
   cd Pfad/zum/IKTMeldung
   ```

2. Die Anwendung mit Docker Compose starten:
   ```
   docker-compose up -d
   ```

3. Die Anwendung ist nun über http://localhost:8080 erreichbar.

### Container stoppen

```
docker-compose down
```

## Entwicklung

Für die Entwicklung werden die lokalen Dateien direkt in den Container gemounted. Jede Änderung an den Dateien wird sofort sichtbar.

## Produktivumgebung

Für eine Produktivumgebung sollte das Volume-Mapping in der docker-compose.yml auskommentiert werden.
