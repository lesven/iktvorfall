# Anforderungen: Interaktive HTML-Seite zur Prüfung von IKT-Vorfällen (DORA)

## 🎯 Ziel

Bereitstellung einer interaktiven Webseite unter `https://vorfall.arz.de`, die Mitarbeitenden hilft, anhand eines strukturierten Entscheidungsbaums zu bewerten, ob ein IKT-Vorfall möglicherweise meldepflichtig im Sinne von DORA ist.  
Falls dies der Fall ist, soll ein Formular zur strukturierten Meldung an den CISO (Nikolas) eingeblendet werden.

---

## 🧩 Funktionale Anforderungen

### 1. Entscheidungsbaum (Fragen/Antworten)
- Benutzerfreundliche Schritt-für-Schritt-Navigation mit Ja/Nein-Auswahl.
- Keine Formularliste, sondern einfache Fragen auf einer Seite (eine nach der anderen).
- Die Logik basiert auf ca. 6 Entscheidungsfragen (siehe HTML-Prototyp).
- Fortschrittsanzeige optional („Frage 3 von 6“ o. ä.).

### 2. Ergebnisanzeige
- Zwei mögliche Ergebnisse:
  - **„Bitte informiere Nikolas über diesen Vorfall.“** → Formular wird eingeblendet.
  - **„Kein meldepflichtiger Vorfall – bitte dokumentiere intern.“**

### 3. Melden Seite mit Email-Link zur Vorfallmeldung (nur wenn notwendig)
- im Email Link sol lder BEtreff vorgegeben sein mit  "ITK Meldung"
- Versand per E-Mail an `nikolas.mustermann@arz.de` **oder** Übergabe an internes Ticketsystem/API.
- Erfolgsmeldung für die Nutzer: „Meldung wurde übermittelt.“
- Kontaktdaten wie Telefon von Nikolas sollen angezeigt werden
- Foto von Nikolas soll angezeigt werden

---

## ⚙️ Technische Anforderungen

- Statische HTML/JS/CSS-Seite oder einfache Web-App (z. B. React).
- Hosting über interne Infrastruktur unter `https://vorfall.arz.de`.
- Kompatibel mit Chrome und Edge (aktuelle Versionen).
- Clientseitig lauffähig, kein externer Backend-Zugriff notwendig (außer optionales E-Mail/API für Formular).
- Optional: Deployment über bestehende CI/CD-Pipeline.
- auf jeder Seite/zu jeder Frage soll es die Möglichkeit geben zusätzliche Texte einzubauen

---

## 🎨 UX/UI-Anforderungen

- Corporate-konforme Gestaltung (Farben, Logo, etc.).
- Mobile Nutzung möglich (responsive Design).
- Klare, einfache Sprache – keine technischen Fachbegriffe.
- Ergebnis farblich hervorheben (z. B. grün bei „kein Risiko“, orange/rot bei „melden“).
- Barrierefrei nutzbar (Tab-Navigation, Screenreader möglich).

---

## 🔐 Datenschutz / Logging

- Keine Speicherung der Entscheidungsbaum-Antworten.
- Nur das ausgefüllte Formular darf versendet oder gespeichert werden.
- Keine personenbezogenen Daten werden außerhalb des Meldungsformulars verarbeitet.

---

## 📎 Anhänge

- HTML-Prototyp zur Orientierung liegt vor.
