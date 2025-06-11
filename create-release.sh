#!/bin/bash
# IKT-Vorfall Docker Release-Script
# Dieses Skript erstellt getaggte Releases des Docker-Images

# Default-Werte
VERSION=""
BUMP_TYPE="patch"
PUSH=false

# Farbdefinitionen
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funktionen
print_colored() {
    COLOR=$2
    if [ -z "$COLOR" ]; then
        COLOR=$NC
    fi
    echo -e "${COLOR}$1${NC}"
}

# Parameter-Parsing
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -v|--version)
      VERSION="$2"
      shift
      shift
      ;;
    -b|--bump)
      BUMP_TYPE="$2"
      shift
      shift
      ;;
    -p|--push)
      PUSH=true
      shift
      ;;
    *)
      # Unbekannter Parameter
      shift
      ;;
  esac
done

# Header
print_colored "===== IKT-Vorfall Docker Release =====" "$CYAN"
echo ""

# Überprüfe, ob Docker läuft
if ! docker info > /dev/null 2>&1; then
    print_colored "Docker ist nicht aktiv! Bitte starte Docker und versuche es erneut." "$RED"
    exit 1
fi

# Bestehende Version laden oder neue erstellen
VERSION_FILE="version.txt"
CURRENT_VERSION="1.0.0"  # Standard-Version

if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
fi

# Wenn keine Version übergeben wurde, verwenden wir das Versionsinkrement
if [ -z "$VERSION" ]; then
    # Semver-Parsing
    IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=${VERSION_PARTS[0]}
    MINOR=${VERSION_PARTS[1]}
    PATCH=${VERSION_PARTS[2]}
    
    # Version inkrementieren basierend auf dem Typ
    case $BUMP_TYPE in
        "major")
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
        "minor")
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        "patch")
            PATCH=$((PATCH + 1))
            ;;
    esac
    
    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
else
    NEW_VERSION="$VERSION"
fi

print_colored "Aktuelle Version: $CURRENT_VERSION" "$YELLOW"
print_colored "Neue Version: $NEW_VERSION" "$GREEN"

# Bestätigung einholen
read -p "Möchtest du fortfahren? (j/n) " CONFIRMATION
if [ "$CONFIRMATION" != "j" ]; then
    print_colored "Abgebrochen." "$RED"
    exit 0
fi

# Version speichern
echo -n "$NEW_VERSION" > "$VERSION_FILE"

# Build Production Image
print_colored "Baue Docker-Image..." "$YELLOW"
docker build -t ikt-vorfall-app:$NEW_VERSION -t ikt-vorfall-app:latest .

# Test Image
print_colored "Starte Testcontainer..." "$YELLOW"
TEST_CONTAINER_ID=$(docker run --name ikt-vorfall-test -d -p 8081:80 ikt-vorfall-app:$NEW_VERSION)
print_colored "Testcontainer gestartet unter: http://localhost:8081" "$GREEN"

# Warten auf Bestätigung
print_colored "Bitte überprüfe die Anwendung und bestätige den Release:" "$CYAN"
read -p "Ist die Anwendung bereit für den Release? (j/n) " RELEASE_CONFIRMATION

# Testcontainer stoppen und entfernen
print_colored "Stoppe und entferne Testcontainer..." "$YELLOW"
docker stop $TEST_CONTAINER_ID
docker rm $TEST_CONTAINER_ID

if [ "$RELEASE_CONFIRMATION" = "j" ]; then
    # Neue Version taggen
    if [ "$PUSH" = true ]; then
        print_colored "Pushe Images zu Docker Registry..." "$YELLOW"
        docker tag ikt-vorfall-app:$NEW_VERSION your-registry/ikt-vorfall-app:$NEW_VERSION
        docker tag ikt-vorfall-app:$NEW_VERSION your-registry/ikt-vorfall-app:latest
        docker push your-registry/ikt-vorfall-app:$NEW_VERSION
        docker push your-registry/ikt-vorfall-app:latest
        print_colored "Images erfolgreich gepusht!" "$GREEN"
    fi
    
    print_colored "Release $NEW_VERSION erfolgreich erstellt!" "$GREEN"
    print_colored "Du kannst die Produktionsumgebung jetzt mit folgendem Befehl aktualisieren:" "$NC"
    print_colored "./deploy-production.sh" "$CYAN"
else
    print_colored "Release abgebrochen." "$RED"
fi
