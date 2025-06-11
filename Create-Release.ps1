# IKT-Vorfall Docker Release-Script
# Dieses Skript erstellt getaggte Releases des Docker-Images

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$Version = "",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("patch", "minor", "major")]
    [string]$BumpType = "patch",
    
    [Parameter(Mandatory=$false)]
    [switch]$Push = $false
)

# Farben für die Ausgabe
function Write-Colored {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [string]$ForegroundColor = "White"
    )
    
    Write-Host $Message -ForegroundColor $ForegroundColor
}

# Header
Write-Colored "===== IKT-Vorfall Docker Release =====" -ForegroundColor Cyan
Write-Colored ""

# Überprüfe, ob Docker läuft
try {
    $null = docker info
} catch {
    Write-Colored "Docker ist nicht aktiv! Bitte starte Docker Desktop und versuche es erneut." -ForegroundColor Red
    exit 1
}

# Bestehende Version laden oder neue erstellen
$versionFile = "version.txt"
$currentVersion = "1.0.0"  # Standard-Version

if (Test-Path $versionFile) {
    $currentVersion = Get-Content $versionFile
}

# Wenn keine Version übergeben wurde, verwenden wir das Versionsinkrement
if ([string]::IsNullOrEmpty($Version)) {
    # Semver-Parsing
    $versionParts = $currentVersion.Split('.')
    $major = [int]$versionParts[0]
    $minor = [int]$versionParts[1]
    $patch = [int]$versionParts[2]
    
    # Version inkrementieren basierend auf dem Typ
    switch ($BumpType) {
        "major" { 
            $major += 1
            $minor = 0
            $patch = 0
        }
        "minor" { 
            $minor += 1
            $patch = 0
        }
        "patch" { 
            $patch += 1
        }
    }
    
    $newVersion = "$major.$minor.$patch"
} else {
    $newVersion = $Version
}

Write-Colored "Aktuelle Version: $currentVersion" -ForegroundColor Yellow
Write-Colored "Neue Version: $newVersion" -ForegroundColor Green

# Bestätigung einholen
$confirmation = Read-Host "Möchtest du fortfahren? (j/n)"
if ($confirmation -ne "j") {
    Write-Colored "Abgebrochen." -ForegroundColor Red
    exit 0
}

# Version speichern
$newVersion | Out-File $versionFile -NoNewline

# Build Production Image
Write-Colored "`nBaue Docker-Image..." -ForegroundColor Yellow
docker build -t ikt-vorfall-app:$newVersion -t ikt-vorfall-app:latest .

# Test Image
Write-Colored "`nStarte Testcontainer..." -ForegroundColor Yellow
$testContainerID = docker run --name ikt-vorfall-test -d -p 8081:80 ikt-vorfall-app:$newVersion
Write-Colored "Testcontainer gestartet unter: http://localhost:8081" -ForegroundColor Green

# Warten auf Bestätigung
Write-Colored "`nBitte überprüfe die Anwendung und bestätige den Release:" -ForegroundColor Cyan
$releaseConfirmation = Read-Host "Ist die Anwendung bereit für den Release? (j/n)"

# Testcontainer stoppen und entfernen
Write-Colored "`nStoppe und entferne Testcontainer..." -ForegroundColor Yellow
docker stop $testContainerID
docker rm $testContainerID

if ($releaseConfirmation -eq "j") {
    # Neue Version taggen
    if ($Push) {
        Write-Colored "`nPushe Images zu Docker Registry..." -ForegroundColor Yellow
        docker tag ikt-vorfall-app:$newVersion your-registry/ikt-vorfall-app:$newVersion
        docker tag ikt-vorfall-app:$newVersion your-registry/ikt-vorfall-app:latest
        docker push your-registry/ikt-vorfall-app:$newVersion
        docker push your-registry/ikt-vorfall-app:latest
        Write-Colored "Images erfolgreich gepusht!" -ForegroundColor Green
    }
    
    Write-Colored "`nRelease $newVersion erfolgreich erstellt!" -ForegroundColor Green
    Write-Colored "Du kannst die Produktionsumgebung jetzt mit folgendem Befehl aktualisieren:" -ForegroundColor White
    Write-Colored ".\Deploy-Production.ps1" -ForegroundColor Cyan
} else {
    Write-Colored "`nRelease abgebrochen." -ForegroundColor Red
}
