# PowerShell-Skript für die Produktionsbereitstellung der IKT-Vorfall-Anwendung

# Variablen
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backupDir = "./backups"

# Ausgabe-Header
Write-Host "=== IKT-Vorfall Produktionsbereitstellung ===" -ForegroundColor Cyan
Write-Host ""

# Backup des vorherigen Zustands erstellen
Write-Host "Erstelle Backup..." -ForegroundColor Yellow
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
}
if (Test-Path "./docker-compose.yml") {
    Copy-Item "./docker-compose.yml" -Destination "$backupDir/docker-compose-$timestamp.yml"
}

# Stoppe alle laufenden Container
Write-Host "Stoppe laufende Container..." -ForegroundColor Yellow
docker-compose down

# Aktualisiere den Code (falls Git verwendet wird)
if (Test-Path ".git") {
    Write-Host "Aktualisiere Code aus Git-Repository..." -ForegroundColor Yellow
    git pull
} else {
    Write-Host "Kein Git-Repository gefunden. Überspringe Code-Update." -ForegroundColor Yellow
}

# Baue Container neu und starte mit Produktionskonfiguration
Write-Host "Baue und starte Container mit Produktionskonfiguration..." -ForegroundColor Yellow
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Warte, bis Container bereit sind
Write-Host "Warte auf Container-Bereitschaft..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Überprüfe, ob alles läuft
Write-Host "Überprüfe Container-Status..." -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "Bereitstellung abgeschlossen!" -ForegroundColor Green
Write-Host "Du kannst die Anwendung unter http://localhost:8080 aufrufen." -ForegroundColor Green

# Warte auf Benutzer-Eingabe
Write-Host ""
Write-Host "Drücke eine beliebige Taste zum Beenden..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
