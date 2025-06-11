# IKT-Vorfall SSL-Zertifikat-Generator
# Dieses Skript erstellt selbstsignierte SSL-Zertifikate für HTTPS in der Entwicklung

param(
    [Parameter(Mandatory=$false)]
    [string]$CommonName = "localhost",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "./ssl",
    
    [Parameter(Mandatory=$false)]
    [int]$ValidDays = 365
)

# Funktionen für farbige Ausgabe
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
Write-Colored "===== IKT-Vorfall SSL-Zertifikat-Generator =====" -ForegroundColor Cyan
Write-Host ""

# Überprüfe OpenSSL-Installation
try {
    $opensslVersion = openssl version
    Write-Colored "OpenSSL gefunden: $opensslVersion" -ForegroundColor Green
} catch {
    Write-Colored "Fehler: OpenSSL ist nicht installiert oder nicht im PATH." -ForegroundColor Red
    Write-Host "Bitte installiere OpenSSL von https://www.openssl.org oder nutze Git Bash/WSL mit vorinstalliertem OpenSSL."
    exit 1
}

# Verzeichnis erstellen, falls es nicht existiert
if (-not (Test-Path $OutputPath)) {
    Write-Colored "Erstelle Verzeichnis $OutputPath..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null
}

# Prüfen, ob Zertifikate bereits vorhanden sind
$certFile = Join-Path -Path $OutputPath -ChildPath "cert.pem"
$keyFile = Join-Path -Path $OutputPath -ChildPath "key.pem"

if ((Test-Path $certFile) -or (Test-Path $keyFile)) {
    Write-Colored "WARNUNG: Zertifikate existieren bereits im Pfad $OutputPath" -ForegroundColor Yellow
    $overwrite = Read-Host "Möchtest du sie überschreiben? (j/n)"
    if ($overwrite -ne "j") {
        Write-Colored "Abgebrochen. Bestehende Zertifikate bleiben erhalten." -ForegroundColor Red
        exit 0
    }
}

# SSL-Konfiguration erstellen
$configFile = Join-Path -Path $OutputPath -ChildPath "openssl.cnf"
$configContent = @"
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_ca

[dn]
C = DE
ST = Nordrhein-Westfalen
L = Haan
O = ARZ Haan AG
OU = IT
CN = $CommonName

[v3_ca]
subjectAltName = @alt_names
basicConstraints = critical, CA:false
keyUsage = critical, digitalSignature, keyAgreement, keyEncipherment
extendedKeyUsage = serverAuth

[alt_names]
DNS.1 = $CommonName
DNS.2 = www.$CommonName
"@

Write-Colored "Erstelle OpenSSL-Konfiguration..." -ForegroundColor Yellow
Set-Content -Path $configFile -Value $configContent

# Generiere privaten Schlüssel und Zertifikat
Write-Colored "Generiere privaten Schlüssel..." -ForegroundColor Yellow
openssl genrsa -out $keyFile 2048

Write-Colored "Generiere selbstsigniertes Zertifikat..." -ForegroundColor Yellow
openssl req -new -x509 -key $keyFile -out $certFile -days $ValidDays -config $configFile

# Verifiziere das Zertifikat
Write-Colored "`nÜberprüfe das generierte Zertifikat:" -ForegroundColor Yellow
openssl x509 -text -noout -in $certFile | Select-String -Pattern "Subject:|Issuer:|Not Before:|Not After :|DNS:"

# Anleitung zur Verwendung
Write-Host "`n" 
Write-Colored "SSL-Zertifikate wurden erfolgreich erstellt:" -ForegroundColor Green
Write-Host "  - Zertifikat: $certFile"
Write-Host "  - Privater Schlüssel: $keyFile"
Write-Host "`n"
Write-Colored "Um HTTPS in der Docker-Konfiguration zu aktivieren:" -ForegroundColor Cyan
Write-Host "1. Kopiere die Zertifikate in einen Verzeichnis innerhalb des Docker-Containers"
Write-Host "2. Aktualisiere docker-compose.yml und füge ein Volume-Mapping für das SSL-Verzeichnis hinzu:"
Write-Host "   - '$OutputPath:/etc/nginx/ssl'"
Write-Host "3. Entkommentiere die HTTPS-Konfiguration in nginx.conf"
Write-Host "4. Entkommentiere den Port-Mapping für 443 in docker-compose.prod.yml"
Write-Host ""
Write-Colored "HINWEIS: Dies ist ein selbstsigniertes Zertifikat für Entwicklungszwecke." -ForegroundColor Yellow
Write-Colored "Für die Produktion sollte ein Zertifikat von einer vertrauenswürdigen Zertifizierungsstelle verwendet werden." -ForegroundColor Yellow
