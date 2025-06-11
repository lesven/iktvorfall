# IKT-Vorfall Prüfung (DORA) - ARZ Haan AG

Eine interaktive Webseite zur Bewertung der Meldepflicht bei IKT-Vorfällen nach DORA mit erweiterten, detaillierten Erklärungen.

## 🎯 Überblick

Diese Anwendung hilft Mitarbeitenden dabei, durch einen strukturierten Entscheidungsbaum zu bewerten, ob ein IKT-Vorfall meldepflichtig ist. Bei einem positiven Ergebnis wird direkt der Kontakt zum CISO (Nikolas) angeboten.

## ✨ Neue Features (Enhanced Version)

### 📚 Umfassende DORA-Erklärungen
- **Detaillierte rechtliche Grundlagen** mit spezifischen DORA-Artikeln
- **Praktische Beispiele** für jede Fragekategorie
- **Strukturierte HTML-Formatierung** für bessere Lesbarkeit
- **Emoji-Icons** zur visuellen Gliederung
- **Responsive Design** für mobile Geräte

### 🔍 Erweiterte Informationsbereiche
Jede Frage enthält jetzt ausführliche Zusatzinformationen:
- **IKT-Systeme**: Hardware, Software, Netzwerke, Cloud-Services, Legacy-Systeme
- **Kritische Funktionen**: Kerngeschäfts- und Support-Funktionen nach DORA
- **Zeitkriterien**: Materialitätsschwellenwerte und quantitative Kriterien
- **Datenschutz**: DORA/DSGVO-Nexus, verschiedene Datentypen
- **Drittanbieter**: Cloud-Provider, Lieferketten, systemische Risiken
- **Cyber-Angriffe**: APT, Ransomware, Social Engineering, DDoS

### 🎨 Verbessertes Design
- **Responsive Layout** für Desktop, Tablet und Mobile
- **Dark Mode Support** für bessere Benutzerfreundlichkeit
- **Print-optimierte Styles** für Dokumentation
- **Accessibility Features** (High Contrast, Reduced Motion)
- **Enhanced CSS** für HTML-formatierten Content

## 🚀 Installation und Bereitstellung

### Lokale Entwicklung
1. Alle Dateien in einen Webserver-Ordner kopieren
2. Webserver starten (z.B. mit Live Server in VS Code)
3. `index.html` im Browser öffnen

### Produktive Bereitstellung
1. Alle Dateien auf den Webserver unter `https://vorfall.arz.de` hochladen
2. Sicherstellen, dass alle Dateien über HTTPS erreichbar sind
3. Photo von Nikolas als `nikolas-photo.jpg` hinzufügen

## 📁 Dateistruktur

```
IKTMeldung/
├── index.html          # Haupt-HTML-Datei
├── styles.css          # Stylesheet
├── script.js           # JavaScript-Logik
├── nikolas-photo.jpg   # Foto des CISO (hinzufügen)
└── README.md           # Diese Datei
```

## ⚙️ Konfiguration

### Kontaktdaten anpassen
In `index.html` und `script.js` können folgende Kontaktdaten angepasst werden:
- E-Mail-Adresse (aktuell: nikolas.mustermann@arz.de)
- Telefonnummern
- Name und Titel

### Fragen anpassen
Die Fragen können in `script.js` in der `questions`-Array angepasst werden:

```javascript
const questions = [
    {
        id: 1,
        title: "Fragetitel",
        text: "Fragetext",
        additionalInfo: "Zusätzliche Informationen (optional)"
    },
    // weitere Fragen...
];
```

### Bewertungslogik anpassen
Die Logik zur Bestimmung der Meldepflicht kann in der `calculateResult()`-Funktion angepasst werden.

## 🎨 Anpassungen

### Corporate Design
- Farben können in `styles.css` angepasst werden
- Logo kann im Header eingefügt werden
- Unternehmens-spezifische Styles können ergänzt werden

### Foto hinzufügen
1. Foto von Nikolas als `nikolas-photo.jpg` speichern
2. Empfohlene Größe: 200x200px oder größer (quadratisch)
3. Unterstützte Formate: JPG, PNG, WebP

## 🔧 Technische Details

### Funktionen
- ✅ 6-Stufen Entscheidungsbaum
- ✅ Responsive Design (Mobile-optimiert)
- ✅ Fortschrittsanzeige
- ✅ Zurück-Navigation
- ✅ Barrierefreie Bedienung
- ✅ Tastatur-Navigation (J/Y = Ja, N = Nein, Esc = Neu starten)
- ✅ E-Mail-Integration mit vordefiniertem Betreff
- ✅ Kontaktinformationen mit Telefonnummern
- ✅ Erfolgsmeldung nach E-Mail-Versand

### Browser-Kompatibilität
- Chrome (aktuelle Version)
- Microsoft Edge (aktuelle Version)
- Firefox (aktuelle Version)
- Safari (aktuelle Version)

### Sicherheit und Datenschutz
- Keine Speicherung von Antworten
- Clientseitige Verarbeitung
- Keine externe API-Aufrufe
- DSGVO-konform

## 🔄 Deployment

### Manuell
1. Dateien per FTP/SFTP auf Webserver hochladen
2. Sicherstellen, dass `index.html` als Standard-Seite konfiguriert ist

### CI/CD Pipeline
Für automatisches Deployment können folgende Schritte in eine Pipeline integriert werden:

```yaml
# Beispiel für Azure DevOps oder GitHub Actions
- name: Deploy to Web Server
  run: |
    # Dateien kopieren
    cp -r . /var/www/vorfall.arz.de/
    # Berechtigungen setzen
    chmod -R 644 /var/www/vorfall.arz.de/
```

## 🧪 Testing

### Funktionstest
1. Alle 6 Fragen durchgehen
2. Verschiedene Antwortszenarien testen
3. Navigation (Zurück, Neu starten) testen
4. Mobile Ansicht testen
5. E-Mail-Links testen

### Accessibility Test
- Tab-Navigation prüfen
- Screen Reader testen
- Kontrast-Verhältnis prüfen
- Tastatur-Navigation testen

## 📞 Support

Bei Fragen oder Problemen:
- IT-Abteilung ARZ Haan AG
- CISO: nikolas.mustermann@arz.de

## 📝 Changelog

### Version 1.0 (2025-06-11)
- Initiale Version
- 6-Fragen Entscheidungsbaum
- Responsive Design
- E-Mail-Integration
- Kontaktseite mit CISO-Informationen

## 📄 Lizenz

© 2025 ARZ Haan AG. Alle Rechte vorbehalten.
