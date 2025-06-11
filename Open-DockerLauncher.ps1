# Docker-Launcher für IKT-Vorfall-Anwendung
# -----------------------------------------

function Test-DockerRunning {
    try {
        $null = docker info
        return $true
    } catch {
        return $false
    }
}

function Start-DockerDesktop {
    $dockerDesktopPath = "$env:PROGRAMFILES\Docker\Docker\Docker Desktop.exe"
    $dockerDesktopStartMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Docker\Docker Desktop.lnk"
    
    if (Test-Path $dockerDesktopPath) {
        Write-Host "Starte Docker Desktop von der Programminstallation..." -ForegroundColor Yellow
        Start-Process $dockerDesktopPath
    } elseif (Test-Path $dockerDesktopStartMenuPath) {
        Write-Host "Starte Docker Desktop über die Startmenü-Verknüpfung..." -ForegroundColor Yellow
        Start-Process $dockerDesktopStartMenuPath
    } else {
        Write-Host "Docker Desktop konnte nicht automatisch gestartet werden." -ForegroundColor Red
        Write-Host "Bitte starte Docker Desktop manuell und führe dieses Skript erneut aus." -ForegroundColor Yellow
        return $false
    }
    
    return $true
}

function Open-Docker {
    $maxAttempts = 10
    $attempts = 0
    $dockerStarted = $false
    
    Write-Host "Docker-Launcher für IKT-Vorfall-Anwendung" -ForegroundColor Cyan
    Write-Host "------------------------------------------" -ForegroundColor DarkGray
    
    # Prüfen, ob Docker Desktop bereits läuft
    if (Test-DockerRunning) {
        Write-Host "✓ Docker läuft bereits." -ForegroundColor Green
        $dockerStarted = $true
    } else {
        Write-Host "Docker ist nicht aktiv. Starte Docker Desktop..." -ForegroundColor Yellow
        
        if (-not (Start-DockerDesktop)) {
            return
        }
        
        Write-Host "Warte, bis Docker bereit ist..." -ForegroundColor Yellow
        
        # Warten, bis Docker bereit ist
        while ($attempts -lt $maxAttempts) {
            $attempts++
            Write-Host "Prüfe Docker-Status... ($attempts/$maxAttempts)" -ForegroundColor DarkYellow
            
            if (Test-DockerRunning) {
                Write-Host "✓ Docker ist jetzt bereit!" -ForegroundColor Green
                $dockerStarted = $true
                break
            }
            
            Start-Sleep -Seconds 5
        }
    }
    
    if (-not $dockerStarted) {
        Write-Host "❌ Docker konnte nicht gestartet werden. Bitte starte Docker Desktop manuell." -ForegroundColor Red
        return
    }
    
    # Docker läuft jetzt, öffne das Dashboard
    Write-Host "Öffne IKT-Vorfall Docker-Dashboard..." -ForegroundColor Cyan
    
    # Prüfen, ob docker-dashboard.html existiert
    $dashboardPath = Join-Path (Get-Location) "docker-dashboard.html"
    if (Test-Path $dashboardPath) {
        Start-Process $dashboardPath
        Write-Host "✓ Dashboard wurde geöffnet." -ForegroundColor Green
    } else {
        Write-Host "❌ Dashboard-Datei nicht gefunden." -ForegroundColor Red
    }
    
    # Starte die IKT-Anwendung mit dem vorhandenen Skript
    $dockerAppScript = Join-Path (Get-Location) "Start-DockerApp.ps1"
    if (Test-Path $dockerAppScript) {
        Write-Host "Starte IKT-Vorfall-Anwendung mit Docker..." -ForegroundColor Yellow
        & $dockerAppScript -Quick
    } else {
        Write-Host "Starter-Skript für IKT-Vorfall-Anwendung nicht gefunden." -ForegroundColor Yellow
        
        # Alternative: Direkt docker-compose aufrufen
        if ((docker ps -q -f "name=ikt-vorfall-app") -eq $null) {
            Write-Host "Starte IKT-Vorfall-Container..." -ForegroundColor Yellow
            docker-compose up -d
        } else {
            Write-Host "IKT-Vorfall-Container läuft bereits." -ForegroundColor Green
        }
    }
    
    Write-Host ""
    Write-Host "Die IKT-Vorfall-Anwendung ist unter http://localhost:8080 verfügbar." -ForegroundColor Green
    
    # Browser öffnen
    $openBrowser = Read-Host "Browser öffnen? (J/n)"
    if ($openBrowser -ne "n" -and $openBrowser -ne "N") {
        Start-Process "http://localhost:8080"
    }
}

# Führe die Hauptfunktion aus
Open-Docker
