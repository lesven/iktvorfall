#!/bin/bash
# Produktionsbereitstellung für die IKT-Vorfall-Anwendung

# Prüfen, ob wir als Root ausgeführt werden
if [ "$EUID" -ne 0 ]; then
  echo "Bitte führe das Skript als Root aus (mit sudo)"
  exit 1
fi

# Variablen
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="./backups"

# Backup des vorherigen Zustands erstellen
echo "Erstelle Backup..."
mkdir -p $BACKUP_DIR
if [ -f "./docker-compose.yml" ]; then
  cp ./docker-compose.yml "$BACKUP_DIR/docker-compose-$TIMESTAMP.yml"
fi

# Stoppe alle laufenden Container
echo "Stoppe laufende Container..."
docker-compose down

# Aktualisiere den Code (falls Git verwendet wird)
if [ -d ".git" ]; then
  echo "Aktualisiere Code aus Git-Repository..."
  git pull
else
  echo "Kein Git-Repository gefunden. Überspringe Code-Update."
fi

# Baue Container neu und starte mit Produktionskonfiguration
echo "Baue und starte Container mit Produktionskonfiguration..."
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Warte, bis Container bereit sind
echo "Warte auf Container-Bereitschaft..."
sleep 10

# Überprüfe, ob alles läuft
echo "Überprüfe Container-Status..."
docker-compose ps

echo ""
echo "Bereitstellung abgeschlossen!"
echo "Du kannst die Anwendung unter http://localhost:8080 aufrufen."
