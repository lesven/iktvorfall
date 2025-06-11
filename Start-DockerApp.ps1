# IKT-Vorfall Docker Startup Helper
# -------------------------
param(
    [switch]$Dev,
    [switch]$Prod,
    [switch]$Quick
)

function Test-DockerRunning {
    try {
        $null = docker info
        return $true
    }
    catch {
        return $false
    }
}

function Start-DockerApp {
    param(
        [bool]$IsProduction = $false,
        [bool]$QuickStart = $false
    )

    Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
    
    # Anzeigen des Logos
    Write-Host ""
    Write-Host "  █ █ █▀▄▀█ ▀█▀ ▄▄ █ █ █▀█ █▀█ █▀▀ ▄▀█ █   █   " -ForegroundColor Cyan
    Write-Host "  █▀█ █ ▀ █  █  ░░ ▀▄▀ █▄█ █▀▄ █▀  █▀█ █▄▄ █▄▄ " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Docker-Umgebung für IKT-Vorfall-Prüfung" -ForegroundColor Cyan
    Write-Host "  ARZ Haan AG" -ForegroundColor DarkCyan
    Write-Host "  ================================================" -ForegroundColor DarkGray
    Write-Host ""

    # Prüfen, ob Docker läuft
    if (-not (Test-DockerRunning)) {
        Write-Host "Docker scheint nicht zu laufen. Bitte starte Docker Desktop." -ForegroundColor Red
        Write-Host "Wenn Docker bereits gestartet wurde, warte einen Moment und versuche es erneut." -ForegroundColor Yellow
        return
    }

    # Container-Status prüfen
    $containerRunning = (docker ps -q -f "name=ikt-vorfall-app") -ne $null
    
    if ($containerRunning -and $QuickStart) {
        Write-Host "IKT-Vorfall-App läuft bereits und kann unter http://localhost:8080 aufgerufen werden." -ForegroundColor Green
        return
    }

    if ($containerRunning) {
        Write-Host "IKT-Vorfall-Container läuft bereits. Möchtest du ihn neu starten?" -ForegroundColor Yellow
        $restart = Read-Host "Neustart durchführen? (j/N)"
        if ($restart -ne "j" -and $restart -ne "J") {
            Write-Host "Die Anwendung kann unter http://localhost:8080 aufgerufen werden." -ForegroundColor Green
            return
        }
        
        Write-Host "Stoppe laufende Container..." -ForegroundColor Yellow
        docker-compose down
    }

    # Container bauen und starten
    if ($IsProduction) {
        Write-Host "Starte Produktionsumgebung..." -ForegroundColor Yellow
        docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
    } else {
        Write-Host "Starte Entwicklungsumgebung..." -ForegroundColor Yellow
        docker-compose up -d
    }

    # Status anzeigen
    Write-Host ""
    Write-Host "Container-Status:" -ForegroundColor Yellow
    docker-compose ps

    Write-Host ""
    Write-Host "Die IKT-Vorfall-Anwendung ist jetzt unter http://localhost:8080 verfügbar!" -ForegroundColor Green
    
    # Browser öffnen
    $openBrowser = Read-Host "Browser öffnen? (J/n)"
    if ($openBrowser -ne "n" -and $openBrowser -ne "N") {
        Start-Process "http://localhost:8080"
    }

    Pop-Location
}

# Hauptprogramm
if ($Prod) {
    Start-DockerApp -IsProduction $true -QuickStart $Quick
} else {
    Start-DockerApp -IsProduction $false -QuickStart $Quick
}
