#!/bin/sh
# Container-Gesundheitsprüfung für IKT-Vorfall Docker

# Prüfparameter
WEBSERVER_PORT=80
WEBSERVER_PROCESS="nginx"
MIN_FREE_SPACE_MB=50
MAX_LOG_SIZE_MB=100
HEALTHCHECK_FILE="/usr/share/nginx/html/health.json"

# Farben für die Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "==============================================="
echo "IKT-Vorfall Docker Container Gesundheitsprüfung"
echo "==============================================="
echo "Ausführungszeitpunkt: $(date)"
echo ""

# Status-Variablen
STATUS="OK"
ISSUES=0

# Funktion zum Protokollieren von Problemen
log_issue() {
    STATUS="ISSUE_DETECTED"
    ISSUES=$((ISSUES + 1))
    echo -e "${RED}[✗] $1${NC}"
}

# Funktion zum Protokollieren von Erfolgen
log_success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

# Funktion zum Protokollieren von Warnungen
log_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# 1. Prüfe, ob der Nginx-Prozess läuft
echo "Prüfe Webserver-Prozess..."
if pgrep -x "$WEBSERVER_PROCESS" > /dev/null; then
    log_success "Nginx-Prozess läuft"
else
    log_issue "Nginx-Prozess konnte nicht gefunden werden"
fi

# 2. Prüfe, ob der Port offen ist
echo "Prüfe Webserver-Port..."
if netstat -tuln | grep -q ":$WEBSERVER_PORT "; then
    log_success "Port $WEBSERVER_PORT ist verfügbar"
else
    log_issue "Port $WEBSERVER_PORT ist nicht verfügbar"
fi

# 3. Prüfe Festplattenplatz
echo "Prüfe Festplattenplatz..."
FREE_SPACE=$(df -m / | awk 'NR==2 {print $4}')
if [ "$FREE_SPACE" -lt "$MIN_FREE_SPACE_MB" ]; then
    log_issue "Nur $FREE_SPACE MB freier Speicher verfügbar (Minimum: $MIN_FREE_SPACE_MB MB)"
else
    log_success "Ausreichend freier Speicherplatz: $FREE_SPACE MB"
fi

# 4. Prüfe Größe der Log-Dateien
echo "Prüfe Log-Dateien..."
LOG_SIZE=$(du -sm /var/log/nginx | awk '{print $1}')
if [ "$LOG_SIZE" -gt "$MAX_LOG_SIZE_MB" ]; then
    log_warning "Log-Dateien sind größer als $MAX_LOG_SIZE_MB MB: $LOG_SIZE MB"
else
    log_success "Log-Dateien sind innerhalb des Grenzwerts: $LOG_SIZE MB"
fi

# 5. Prüfe Webserver-Konfiguration
echo "Prüfe Webserver-Konfiguration..."
if nginx -t &>/dev/null; then
    log_success "Nginx-Konfiguration ist gültig"
else
    log_issue "Nginx-Konfiguration ist ungültig"
    nginx -t
fi

# 6. Prüfe wichtige Dateien
echo "Prüfe wichtige Anwendungsdateien..."
REQUIRED_FILES="/usr/share/nginx/html/index.html /usr/share/nginx/html/script.js /usr/share/nginx/html/styles.css"
for file in $REQUIRED_FILES; do
    if [ -f "$file" ]; then
        log_success "Datei existiert: $file"
    else
        log_issue "Datei fehlt: $file"
    fi
done

# Zusammenfassung
echo ""
echo "==============================================="
echo "Zusammenfassung der Gesundheitsprüfung"
echo "==============================================="
if [ "$ISSUES" -eq 0 ]; then
    echo -e "${GREEN}Alle Prüfungen erfolgreich bestanden.${NC}"
    HEALTH_STATUS="healthy"
else
    echo -e "${RED}Es wurden $ISSUES Probleme erkannt.${NC}"
    HEALTH_STATUS="unhealthy"
fi

# Erstelle Gesundheits-JSON-Datei für externe Überwachung
cat > $HEALTHCHECK_FILE << EOF
{
  "status": "$HEALTH_STATUS",
  "timestamp": "$(date +"%Y-%m-%d %H:%M:%S")",
  "issues": $ISSUES,
  "system": {
    "disk_free_mb": $FREE_SPACE,
    "log_size_mb": $LOG_SIZE,
    "webserver_running": $(pgrep -x "$WEBSERVER_PROCESS" > /dev/null && echo "true" || echo "false")
  }
}
EOF

echo "Gesundheitsstatus wurde in $HEALTHCHECK_FILE gespeichert."
echo ""

# Exit mit entsprechendem Status-Code
if [ "$ISSUES" -gt 0 ]; then
    exit 1
else
    exit 0
fi
