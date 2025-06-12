#!/bin/bash
# Dieses Skript prüft die Nginx-Konfiguration auf No-Cache-Einstellungen

echo "=== Prüfe Nginx Cache-Konfiguration ==="
echo

# Pfade
NGINX_CONFIG="./nginx.conf"
HTML_FILE="./index.html"

# Prüfe die Nginx-Konfiguration
echo "Prüfe Nginx Konfiguration..."
if grep -q "Cache-Control.*no-cache" "$NGINX_CONFIG"; then
    echo "✓ Cache-Control Header in Nginx-Konfiguration gefunden."
else
    echo "✗ Keine Cache-Control Header in Nginx-Konfiguration gefunden."
fi

if grep -q "Pragma.*no-cache" "$NGINX_CONFIG"; then
    echo "✓ Pragma no-cache Header in Nginx-Konfiguration gefunden."
else
    echo "✗ Kein Pragma no-cache Header in Nginx-Konfiguration gefunden."
fi

if grep -q "Expires.*0" "$NGINX_CONFIG"; then
    echo "✓ Expires Header in Nginx-Konfiguration gefunden."
else
    echo "✗ Kein Expires Header in Nginx-Konfiguration gefunden."
fi

echo

# Prüfe die HTML-Datei
echo "Prüfe HTML Meta-Tags..."
if grep -q "http-equiv=\"Cache-Control\"" "$HTML_FILE"; then
    echo "✓ Cache-Control Meta-Tag in HTML gefunden."
else
    echo "✗ Kein Cache-Control Meta-Tag in HTML gefunden."
fi

if grep -q "http-equiv=\"Pragma\"" "$HTML_FILE"; then
    echo "✓ Pragma Meta-Tag in HTML gefunden."
else
    echo "✗ Kein Pragma Meta-Tag in HTML gefunden."
fi

if grep -q "http-equiv=\"Expires\"" "$HTML_FILE"; then
    echo "✓ Expires Meta-Tag in HTML gefunden."
else
    echo "✗ Kein Expires Meta-Tag in HTML gefunden."
fi

echo
echo "Prüfung abgeschlossen."
