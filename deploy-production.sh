#!/bin/bash
# Produktionsbereitstellung für die IKT-Vorfall-Anwendung

# Farbdefinitionen
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_colored() {
    COLOR=$2
    if [ -z "$COLOR" ]; then
        COLOR=$NC
    fi
    echo -e "${COLOR}$1${NC}"
}

# Variablen
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR="./backups"
VERSION_FILE="./version.txt"

print_colored "=== IKT-Vorfall Produktionsbereitstellung ===" "$CYAN"
echo ""

# Überprüfe Docker-Status
if ! docker info > /dev/null 2>&1; then
    print_colored "Docker ist nicht aktiv! Bitte starte Docker und versuche es erneut." "$RED"
    exit 1
fi

# Version ermitteln
VERSION="latest"
if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE")
    print_colored "Verwende Version: $VERSION" "$GREEN"
else
    print_colored "Keine spezifische Version gefunden. Verwende 'latest'." "$YELLOW"
fi

# Backup des vorherigen Zustands erstellen
print_colored "Erstelle Backup..." "$YELLOW"
mkdir -p $BACKUP_DIR
if [ -f "./docker-compose.yml" ]; then
  cp ./docker-compose.yml "$BACKUP_DIR/docker-compose-$TIMESTAMP.yml"
fi
if [ -f "./docker-compose.prod.yml" ]; then
  cp ./docker-compose.prod.yml "$BACKUP_DIR/docker-compose.prod-$TIMESTAMP.yml"
fi

# Stoppe alle laufenden Container
print_colored "Stoppe laufende Container..." "$YELLOW"
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

# Aktualisiere den Code (falls Git verwendet wird)
if [ -d ".git" ]; then
  print_colored "Aktualisiere Code aus Git-Repository..." "$YELLOW"
  git pull
else
  print_colored "Kein Git-Repository gefunden. Überspringe Code-Update." "$YELLOW"
fi

# Starte den Produktions-Container
print_colored "Starte IKT-Vorfall-Anwendung in der Produktion..." "$YELLOW"

# Überprüfe, ob ein vorkonfiguriertes Image verwendet werden soll
USE_BUILT_IMAGE=false
read -p "Möchtest du das vorkonfigurierte Image 'ikt-vorfall-app:$VERSION' verwenden? (j/n) " CONFIRMATION
if [ "$CONFIRMATION" = "j" ]; then
    USE_BUILT_IMAGE=true
    
    # Aktualisiere die Produktionskonfiguration
    print_colored "Aktualisiere Produktionskonfiguration..." "$YELLOW"
    
    # Stelle sicher, dass das Image auf dem aktuellen System existiert
    if ! docker image inspect "ikt-vorfall-app:$VERSION" > /dev/null 2>&1; then
        print_colored "WARNUNG: Das Image 'ikt-vorfall-app:$VERSION' wurde nicht gefunden." "$RED"
        read -p "Möchtest du es jetzt erstellen? (j/n) " BUILD_CONFIRMATION
        if [ "$BUILD_CONFIRMATION" = "j" ]; then
            docker build -t "ikt-vorfall-app:$VERSION" -t "ikt-vorfall-app:latest" .
        else
            USE_BUILT_IMAGE=false
        fi
    fi
fi

if [ "$USE_BUILT_IMAGE" = true ]; then
    # Verwende das vorkonfigurierte Image
    print_colored "Starte Container mit vorkonfiguriertem Image..." "$YELLOW"
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
else
    # Baue ein neues Image und starte den Container
    print_colored "Baue und starte Container..." "$YELLOW"
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
fi

print_colored "Produktionsbereitstellung abgeschlossen!" "$GREEN"
print_colored "Die Anwendung ist jetzt unter http://localhost:80 verfügbar." "$GREEN"

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
