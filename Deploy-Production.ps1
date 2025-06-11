# PowerShell-Skript für die Produktionsbereitstellung der IKT-Vorfall-Anwendung

# Variablen
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$backupDir = "./backups"
$versionFile = "./version.txt"

# Ausgabe-Header
Write-Host "=== IKT-Vorfall Produktionsbereitstellung ===" -ForegroundColor Cyan
Write-Host ""

# Überprüfe Docker-Status
try {
    $null = docker info
} catch {
    Write-Host "Docker ist nicht aktiv! Bitte starte Docker Desktop und versuche es erneut." -ForegroundColor Red
    exit 1
}

# Version ermitteln
$version = "latest"
if (Test-Path $versionFile) {
    $version = Get-Content $versionFile
    Write-Host "Verwende Version: $version" -ForegroundColor Green
} else {
    Write-Host "Keine spezifische Version gefunden. Verwende 'latest'." -ForegroundColor Yellow
}

# Backup des vorherigen Zustands erstellen
Write-Host "Erstelle Backup..." -ForegroundColor Yellow
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
}
if (Test-Path "./docker-compose.yml") {
    Copy-Item "./docker-compose.yml" -Destination "$backupDir/docker-compose-$timestamp.yml"
}
if (Test-Path "./docker-compose.prod.yml") {
    Copy-Item "./docker-compose.prod.yml" -Destination "$backupDir/docker-compose.prod-$timestamp.yml"
}

# Stoppe alle laufenden Container
Write-Host "Stoppe laufende Container..." -ForegroundColor Yellow
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down

# Aktualisiere den Code (falls Git verwendet wird)
if (Test-Path ".git") {
    Write-Host "Aktualisiere Code aus Git-Repository..." -ForegroundColor Yellow
    git pull
} else {
    Write-Host "Kein Git-Repository gefunden. Überspringe Code-Update." -ForegroundColor Yellow
}

# Starte den Produktions-Container
Write-Host "Starte IKT-Vorfall-Anwendung in der Produktion..." -ForegroundColor Yellow

# Überprüfe, ob ein vorkonfiguriertes Image verwendet werden soll
$useBuiltImage = $false
$confirmation = Read-Host "Möchtest du das vorkonfigurierte Image 'ikt-vorfall-app:$version' verwenden? (j/n)"
if ($confirmation -eq "j") {
    $useBuiltImage = $true
    
    # Aktualisiere die Produktionskonfiguration
    Write-Host "Aktualisiere Produktionskonfiguration..." -ForegroundColor Yellow
    
    # Stelle sicher, dass das Image auf dem aktuellen System existiert
    $imageExists = docker image inspect "ikt-vorfall-app:$version" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "WARNUNG: Das Image 'ikt-vorfall-app:$version' wurde nicht gefunden." -ForegroundColor Red
        $buildConfirmation = Read-Host "Möchtest du es jetzt erstellen? (j/n)"
        if ($buildConfirmation -eq "j") {
            docker build -t "ikt-vorfall-app:$version" -t "ikt-vorfall-app:latest" .
        } else {
            $useBuiltImage = $false
        }
    }
}

if ($useBuiltImage) {
    # Verwende das vorkonfigurierte Image
    Write-Host "Starte Container mit vorkonfiguriertem Image..." -ForegroundColor Yellow
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
} else {
    # Baue ein neues Image und starte den Container
    Write-Host "Baue und starte Container..." -ForegroundColor Yellow
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build -d
}

Write-Host "`nProduktionsbereitstellung abgeschlossen!" -ForegroundColor Green
Write-Host "Die Anwendung ist jetzt unter http://localhost:80 verfügbar." -ForegroundColor Green

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
