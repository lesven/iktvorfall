# IKT-Vorfall Docker Helper
# -------------------------

function Show-Menu {
    Clear-Host
    Write-Host "=== IKT-Vorfall Docker Management ===" -ForegroundColor Cyan
    Write-Host "1: Container starten"
    Write-Host "2: Container stoppen"
    Write-Host "3: Container-Status anzeigen"
    Write-Host "4: Logs anzeigen"
    Write-Host "5: Container neu bauen und starten"
    Write-Host "Q: Beenden"
}

function Start-IktContainer {
    Write-Host "`nStarte IKT-Vorfall Container..." -ForegroundColor Yellow
    docker-compose up -d
    
    Write-Host "`nDie Anwendung ist jetzt unter http://localhost:8080 verfügbar." -ForegroundColor Green
    Write-Host "Drücke eine Taste zum Fortfahren..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Stop-IktContainer {
    Write-Host "`nStoppe IKT-Vorfall Container..." -ForegroundColor Yellow
    docker-compose down
    
    Write-Host "`nContainer wurden gestoppt." -ForegroundColor Green
    Write-Host "Drücke eine Taste zum Fortfahren..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-Status {
    Write-Host "`nAktueller Container-Status:" -ForegroundColor Yellow
    docker-compose ps
    
    Write-Host "`nDrücke eine Taste zum Fortfahren..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-Logs {
    Write-Host "`nContainer-Logs:" -ForegroundColor Yellow
    docker-compose logs
    
    Write-Host "`nDrücke eine Taste zum Fortfahren..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Rebuild-Container {
    Write-Host "`nContainer werden neu gebaut..." -ForegroundColor Yellow
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    
    Write-Host "`nContainer wurden neu gebaut und gestartet." -ForegroundColor Green
    Write-Host "Die Anwendung ist jetzt unter http://localhost:8080 verfügbar." -ForegroundColor Green
    Write-Host "Drücke eine Taste zum Fortfahren..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Hauptprogramm
do {
    Show-Menu
    $choice = Read-Host "`nWähle eine Option"
    
    switch ($choice) {
        '1' { Start-IktContainer }
        '2' { Stop-IktContainer }
        '3' { Show-Status }
        '4' { Show-Logs }
        '5' { Rebuild-Container }
        'Q' { return }
        'q' { return }
        default { 
            Write-Host "`nUngültige Eingabe!" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} until ($choice -eq 'Q' -or $choice -eq 'q')
