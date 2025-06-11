# IKT-Vorfall Docker-Setup: Wiki-Dokumentation

## Überblick

Die IKT-Vorfall-Anwendung wurde in einem Docker-Container verpackt, um eine einfache Bereitstellung und Konsistenz zwischen verschiedenen Umgebungen zu gewährleisten. Diese Dokumentation beschreibt die Einrichtung und Verwendung der Anwendung mit Docker.

## Schnellstart

### Voraussetzungen

- Docker Desktop installiert (Windows/Mac) oder Docker-Engine (Linux)
- PowerShell 5.1 oder höher (Windows) oder Bash-Shell (Linux/Mac)

### Installation

1. Klonen/Kopieren Sie das Repository in einen lokalen Ordner
2. Navigieren Sie zum Projektverzeichnis
3. Führen Sie das Startskript aus:

   **Windows:**
   ```
   .\Open-DockerLauncher.ps1
   ```

   **Linux/Mac:**
   ```
   ./deploy-production.sh
   ```

4. Öffnen Sie einen Browser und navigieren Sie zu:
   ```
   http://localhost:8080
   ```

## Detaillierte Dokumentation

### Architektur

Die IKT-Vorfall-Anwendung ist als statische Web-Anwendung implementiert, die über einen Nginx-Webserver bereitgestellt wird. Die gesamte Anwendung ist in einem Docker-Container gekapselt.

#### Komponenten

- **Docker-Image**: Basiert auf Alpine Linux mit Nginx
- **Web-Server**: Nginx für das Serving der statischen Inhalte
- **Anwendung**: HTML, CSS und JavaScript für das Frontend

### Docker-Konfiguration

Die Docker-Einrichtung besteht aus folgenden Dateien:

| Datei | Zweck |
|-------|-------|
| `Dockerfile` | Definiert das Docker-Image mit Nginx |
| `docker-compose.yml` | Definiert den Container-Service und die Netzwerkeinstellungen |
| `docker-compose.prod.yml` | Produktionsspezifische Überschreibungen |
| `nginx.conf` | Konfiguration des Nginx-Webservers |

### Bereitstellungsszenarien

#### Entwicklungsumgebung

In einer Entwicklungsumgebung werden die Quellcodedateien als Volume in den Container eingebunden, um schnelle Änderungen zu ermöglichen.

```powershell
docker-compose up -d
```

#### Produktionsumgebung

Für die Produktionsumgebung wird das Volume-Mapping entfernt und zusätzliche Sicherheits- und Performance-Optimierungen vorgenommen.

```powershell
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Hilfsskripen

Das Repository enthält mehrere Hilfsskripten zur einfacheren Verwaltung:

| Skript | Zweck |
|--------|-------|
| `Open-DockerLauncher.ps1` | Startet Docker Desktop und die Anwendung |
| `Start-DockerApp.ps1` | PowerShell-Skript für verschiedene Startmodi |
| `docker-manage.ps1` | PowerShell-Menü für Docker-Verwaltungsaufgaben |
| `Deploy-Production.ps1` | PowerShell-Skript für die Produktionsbereitstellung |
| `deploy-production.sh` | Bash-Skript für die Produktionsbereitstellung unter Linux/Mac |

### Portmapping

Die Anwendung ist standardmäßig auf Port 8080 erreichbar:

- **Externer Port**: 8080 (auf dem Host-System)
- **Interner Port**: 80 (im Container)

Um den externen Port zu ändern, bearbeiten Sie die `ports`-Einstellung in der `docker-compose.yml`:

```yaml
ports:
  - "8081:80"  # Ändert den externen Port auf 8081
```

### Monitoring und Wartung

#### Container-Status prüfen

```powershell
docker-compose ps
```

#### Logs anzeigen

```powershell
docker-compose logs -f
```

#### Container neustarten

```powershell
docker-compose restart
```

#### Container stoppen

```powershell
docker-compose down
```

### Fehlerbehebung

#### Docker Desktop startet nicht

**Problem**: Docker Desktop startet nicht automatisch oder zeigt einen Fehler an.

**Lösung**: 
1. Starten Sie Docker Desktop manuell über das Startmenü
2. Warten Sie, bis die Docker-Engine vollständig gestartet ist
3. Führen Sie das Startskript erneut aus

#### Port bereits in Verwendung

**Problem**: Fehler "Port is already allocated" beim Starten des Containers

**Lösung**:
1. Ändern Sie den externen Port in der `docker-compose.yml`
2. Stoppen Sie die Anwendung, die den Port verwendet
3. Führen Sie `docker-compose down` aus und starten Sie den Container neu

#### Container startet nicht

**Problem**: Container wird erstellt, startet aber nicht

**Lösung**:
1. Prüfen Sie die Logs: `docker-compose logs`
2. Stellen Sie sicher, dass alle benötigten Dateien im Repository vorhanden sind
3. Überprüfen Sie die Nginx-Konfiguration auf Syntaxfehler

## Sicherheitshinweise

- Die Anwendung ist für den internen Einsatz konzipiert
- In der Standardkonfiguration sind keine sensiblen Daten enthalten
- Stellen Sie sicher, dass der externe Port (8080) nicht öffentlich zugänglich ist
- Für eine öffentliche Bereitstellung sollte ein Reverse-Proxy mit HTTPS verwendet werden

## Zukünftige Erweiterungen

- Integration mit Docker Swarm oder Kubernetes für Hochverfügbarkeit
- Automatische Updates über CI/CD-Pipeline
- Integration von Prometheus und Grafana für erweiterte Überwachung

## Ressourcen

- [Offizielle Docker-Dokumentation](https://docs.docker.com/)
- [Nginx-Dokumentation](https://nginx.org/en/docs/)
- [Docker Compose Referenz](https://docs.docker.com/compose/reference/)
