# PowerShell-Skript zur Prüfung der Nginx Cache-Konfiguration

Write-Host "=== Prüfe Nginx Cache-Konfiguration ===" -ForegroundColor Cyan
Write-Host

# Pfade
$NginxConfig = ".\nginx.conf"
$HtmlFile = ".\index.html"

# Prüfe die Nginx-Konfiguration
Write-Host "Prüfe Nginx Konfiguration..." -ForegroundColor Yellow
$nginxContent = Get-Content $NginxConfig -Raw

if ($nginxContent -match "Cache-Control.*no-cache") {
    Write-Host "✓ Cache-Control Header in Nginx-Konfiguration gefunden." -ForegroundColor Green
} else {
    Write-Host "✗ Keine Cache-Control Header in Nginx-Konfiguration gefunden." -ForegroundColor Red
}

if ($nginxContent -match "Pragma.*no-cache") {
    Write-Host "✓ Pragma no-cache Header in Nginx-Konfiguration gefunden." -ForegroundColor Green
} else {
    Write-Host "✗ Kein Pragma no-cache Header in Nginx-Konfiguration gefunden." -ForegroundColor Red
}

if ($nginxContent -match "Expires.*0") {
    Write-Host "✓ Expires Header in Nginx-Konfiguration gefunden." -ForegroundColor Green
} else {
    Write-Host "✗ Kein Expires Header in Nginx-Konfiguration gefunden." -ForegroundColor Red
}

Write-Host

# Prüfe die HTML-Datei
Write-Host "Prüfe HTML Meta-Tags..." -ForegroundColor Yellow
$htmlContent = Get-Content $HtmlFile -Raw

if ($htmlContent -match "http-equiv=`"Cache-Control`"") {
    Write-Host "✓ Cache-Control Meta-Tag in HTML gefunden." -ForegroundColor Green
} else {
    Write-Host "✗ Kein Cache-Control Meta-Tag in HTML gefunden." -ForegroundColor Red
}

if ($htmlContent -match "http-equiv=`"Pragma`"") {
    Write-Host "✓ Pragma Meta-Tag in HTML gefunden." -ForegroundColor Green
} else {
    Write-Host "✗ Kein Pragma Meta-Tag in HTML gefunden." -ForegroundColor Red
}

if ($htmlContent -match "http-equiv=`"Expires`"") {
    Write-Host "✓ Expires Meta-Tag in HTML gefunden." -ForegroundColor Green
} else {
    Write-Host "✗ Kein Expires Meta-Tag in HTML gefunden." -ForegroundColor Red
}

Write-Host
Write-Host "Prüfung abgeschlossen." -ForegroundColor Cyan
