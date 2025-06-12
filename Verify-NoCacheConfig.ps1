# Verify-NoCacheConfig.ps1
# Dieses Skript verifiziert alle No-Cache-Einstellungen für die IKT-Vorfall-App

Write-Host "=== Cache-Konfiguration prüfen ===`n" -ForegroundColor Cyan

# Dateipfade
$htmlFile = ".\index.html"
$nginxConfig = ".\nginx.conf"
$versionJs = ".\version.js"
$dockerfile = ".\Dockerfile"

# Funktion zum Anzeigen des Prüfstatus
function Show-CheckResult {
    param (
        [string]$Description,
        [bool]$Result,
        [string]$Details = ""
    )
    
    if ($Result) {
        Write-Host "✓ $Description" -ForegroundColor Green
    } else {
        Write-Host "✗ $Description" -ForegroundColor Red
    }
    
    if ($Details) {
        Write-Host "  $Details" -ForegroundColor Gray
    }
}

# 1. HTML Meta-Tags prüfen
Write-Host "`nPrüfe HTML Meta-Tags:`n" -ForegroundColor Yellow
$htmlContent = Get-Content -Path $htmlFile -Raw

$hasCacheControlMeta = $htmlContent -match 'http-equiv="Cache-Control"'
Show-CheckResult -Description "Cache-Control META Tag" -Result $hasCacheControlMeta

$hasPragmaMeta = $htmlContent -match 'http-equiv="Pragma"'
Show-CheckResult -Description "Pragma META Tag" -Result $hasPragmaMeta

$hasExpiresMeta = $htmlContent -match 'http-equiv="Expires"'
Show-CheckResult -Description "Expires META Tag" -Result $hasExpiresMeta

$hasVersionJS = $htmlContent -match 'src="version.js"'
Show-CheckResult -Description "Version.js eingebunden" -Result $hasVersionJS

# 2. Nginx Konfiguration prüfen
Write-Host "`nPrüfe Nginx Konfiguration:`n" -ForegroundColor Yellow
$nginxContent = Get-Content -Path $nginxConfig -Raw

$hasNoCacheHeader = $nginxContent -match 'add_header Cache-Control "no-store'
Show-CheckResult -Description "Cache-Control Header" -Result $hasNoCacheHeader

$hasPragmaHeader = $nginxContent -match 'add_header Pragma "no-cache"'
Show-CheckResult -Description "Pragma Header" -Result $hasPragmaHeader

$hasExpiresHeader = $nginxContent -match 'add_header Expires "0"'
Show-CheckResult -Description "Expires Header" -Result $hasExpiresHeader

$hasHtmlRules = $nginxContent -match '\.html'
Show-CheckResult -Description "Spezielle Regeln für HTML-Dateien" -Result $hasHtmlRules

# 3. Version.js Funktionalitäten prüfen
Write-Host "`nPrüfe Version.js:`n" -ForegroundColor Yellow
$versionJsContent = Get-Content -Path $versionJs -Raw

$hasSessionId = $versionJsContent -match 'sessionId'
Show-CheckResult -Description "Dynamische Session-ID" -Result $hasSessionId

$hasResourceCacheBusting = $versionJsContent -match 'addCacheBusterToResources'
Show-CheckResult -Description "Dynamische Ressourcen-URLs" -Result $hasResourceCacheBusting

$hasPageShowReload = $versionJsContent -match 'pageshow.*reload'
Show-CheckResult -Description "Neuladen bei zurück-Navigation" -Result $hasPageShowReload

# 4. Dockerfile prüfen
Write-Host "`nPrüfe Dockerfile:`n" -ForegroundColor Yellow
$dockerfileContent = Get-Content -Path $dockerfile -Raw

$hasTimestamp = $dockerfileContent -match 'Build timestamp'
Show-CheckResult -Description "Build-Zeitstempel" -Result $hasTimestamp

$hasBuildId = $dockerfileContent -match 'BUILD_TIMESTAMP'
Show-CheckResult -Description "Eindeutige Build-ID" -Result $hasBuildId

$hasNoCacheCmd = $dockerfileContent -match 'proxy_buffering off'
Show-CheckResult -Description "Nginx No-Cache Konfiguration" -Result $hasNoCacheCmd

# Zusammenfassung anzeigen
Write-Host "`nZusammenfassung:" -ForegroundColor Cyan
$totalChecks = 14
$passedChecks = @($hasCacheControlMeta, $hasPragmaMeta, $hasExpiresMeta, $hasVersionJS,
                  $hasNoCacheHeader, $hasPragmaHeader, $hasExpiresHeader, $hasHtmlRules,
                  $hasSessionId, $hasResourceCacheBusting, $hasPageShowReload,
                  $hasTimestamp, $hasBuildId, $hasNoCacheCmd) | Where-Object {$_ -eq $true} | Measure-Object | Select-Object -ExpandProperty Count

$passRate = [math]::Round(($passedChecks / $totalChecks) * 100)

Write-Host "$passedChecks von $totalChecks Überprüfungen erfolgreich ($passRate%)" -ForegroundColor $(if ($passRate -eq 100) {"Green"} else {"Yellow"})

if ($passRate -eq 100) {
    Write-Host "`nAlle No-Cache-Konfigurationen sind korrekt eingerichtet!" -ForegroundColor Green
} else {
    Write-Host "`nEs wurden einige Probleme festgestellt. Bitte überprüfen Sie die markierten Punkte." -ForegroundColor Yellow
}

# Empfehlung für Tests
Write-Host "`nTipp: Um das Caching-Verhalten zu testen:" -ForegroundColor Cyan
Write-Host "1. Starten Sie die Docker-Container mit 'docker-compose up'"
Write-Host "2. Öffnen Sie die Anwendung im Browser"
Write-Host "3. Überprüfen Sie mit F12 > Network, ob Cache-Control-Header korrekt gesetzt werden"
Write-Host "4. Testen Sie das Verhalten beim Zurück-Button und Neuladen der Seite"
