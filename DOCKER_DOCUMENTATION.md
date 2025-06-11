# IKT-Vorfall Docker-Konfiguration

Diese Dokumentation beschreibt die Docker-Konfiguration der IKT-Vorfall-Anwendung im Detail.

## Überblick

Die IKT-Vorfall-Anwendung ist als Web-Anwendung konzipiert, die in einem Docker-Container mit Nginx als Webserver ausgeführt wird. Die Konfiguration umfasst:

- Ein Docker-Image basierend auf Alpine Linux mit Nginx
- Nginx-Konfiguration für optimale Performance und Sicherheit
- Docker Compose für einfache Bereitstellung und Verwaltung
- Separate Konfigurationen für Entwicklung und Produktion

## Architektur

```
┌─────────────────┐
│    Nginx        │ Port 80 (intern)
│  Web Server     │◄────────────┐
└─────────────────┘             │
         │                      │
         │                      │
         ▼                      │
┌─────────────────┐      ┌──────┴──────┐
│   Static Files  │      │   Browser   │ Port 8080 (extern)
│  HTML/CSS/JS    │      │             │
└─────────────────┘      └─────────────┘
```

## Komponenten

### Dockerfile

Der `Dockerfile` definiert das Docker-Image:

- Basiert auf `nginx:alpine` für ein schlankes Basis-Image
- Kopiert die Anwendungsdateien in das Webroot-Verzeichnis von Nginx
- Konfiguriert Nginx mit der angepassten Konfigurationsdatei

### docker-compose.yml

Die `docker-compose.yml`-Datei orchestriert die Container:

- Definiert einen Service namens `ikt-app`
- Konfiguriert das Mapping von Port 8080 (Host) zu Port 80 (Container)
- Montiert das lokale Verzeichnis für die Entwicklung
- Konfiguriert einen Healthcheck für die Überwachung
- Stellt die Container-Neustart-Richtlinie ein

### docker-compose.prod.yml

Die `docker-compose.prod.yml`-Datei enthält produktionsspezifische Überschreibungen:

- Entfernt das Volume-Mapping
- Setzt Umgebungsvariablen für die Produktion
- Konfiguriert erweiterte Logging-Optionen

### nginx.conf

Die `nginx.conf`-Datei konfiguriert den Nginx-Webserver:

- Aktiviert und optimiert Gzip-Kompression
- Setzt Sicherheits-Header wie Content-Security-Policy
- Konfiguriert CORS für API-Zugriffe
- Optimiert das Caching von statischen Ressourcen
- Richtet einen Gesundheitsprüfungspunkt ein

## Verwendung

### Für die Entwicklung

```powershell
# Container bauen und starten
docker-compose up -d

# In den Logs nachsehen
docker-compose logs -f
```

### Für die Produktion

```powershell
# Mit Produktionskonfiguration bauen und starten
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Alternativ: Deploy-Skript verwenden
./Deploy-Production.ps1  # Windows
./deploy-production.sh   # Linux/macOS
```

### Container-Verwaltung

```powershell
# Container-Status überprüfen
docker-compose ps

# Container stoppen
docker-compose down

# Container neu bauen (bei Codeänderungen)
docker-compose build --no-cache
```

## Sicherheitsaspekte

Die Konfiguration beinhaltet mehrere Sicherheitsmaßnahmen:

- **Security Headers**: Schutz vor XSS, Clickjacking und MIME-Type-Sniffing
- **Content Security Policy**: Einschränkung des Ressourcenzugriffs
- **CORS-Konfiguration**: Kontrolle des domainübergreifenden Zugriffs
- **Alpine Linux**: Reduzierter Angriffsvektor durch minimale Basis
- **Separate Prodüktionseinstellungen**: Erhöhte Sicherheit in der Produktion

## Leistungsoptimierungen

- **Gzip-Kompression**: Reduziert die Übertragungsgröße von Ressourcen
- **Browser-Caching**: Optimiert die Ladezeiten für wiederkehrende Besucher
- **TCP-Optimierungen**: Verbessert die Netzwerkleistung
- **Alpine-Basis**: Geringerer Ressourcenverbrauch

## Fehlerbehebung

### Container startet nicht

Überprüfe die Docker-Logs:

```powershell
docker-compose logs ikt-app
```

### Port-Konflikt

Falls Port 8080 bereits verwendet wird, ändere den Port in `docker-compose.yml`:

```yaml
ports:
  - "8081:80"  # Alternativer Port
```

### Dateiberechtigungsprobleme

Bei Berechtigungsproblemen in Linux/macOS:

```bash
chmod -R 755 .
```

## Wartung

### Regelmäßige Updates

Führe regelmäßig Updates des Basis-Images durch:

```powershell
docker-compose pull
docker-compose up -d --build
```

### Backup

Sichere die Konfigurationsdateien regelmäßig. Die bereitgestellten Skripte erstellen automatisch Backups im `./backups`-Verzeichnis.
