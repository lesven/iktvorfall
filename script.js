// Fragebogen-Konfiguration
const questions = [    {
        id: 1,
        title: "Betrifft der Vorfall IKT-Systeme?",
        text: "Ist ein Computer-System (Server, Netzwerk, Software, etc.) betroffen?",        additionalInfo: `
        <strong>🔧 Was sind IKT-Systeme?</strong><br>
        Alle Computer-Systeme in deinem Unternehmen:<br><br>
        
        • Server, Computer, Handys<br>
        • Banking-Programme, Windows, Apps<br>
        • Internet, WLAN, Firmen-Netzwerk<br>
        • Microsoft 365, Google Drive, Cloud-Services<br><br>
        
        <strong>⚠️ Auch das zählt:</strong><br>
        • Stromausfall, Wasserschaden<br>
        • Nur ein Teil des Systems kaputt<br><br>
        
        <strong>💡 Beispiele:</strong><br>
        ✅ Online-Banking funktioniert nicht<br>
        ✅ E-Mail geht nicht<br>
        ✅ Handy-App stürzt ab<br>
        ✅ Server fällt aus
        `
    },    {
        id: 2,
        title: "Sind kritische oder wichtige Geschäftsfunktionen betroffen?",
        text: "Stört der Vorfall wichtige Arbeitsabläufe in deinem Unternehmen?",
        additionalInfo: `
        <strong>🏦 Wichtige Geschäftsfunktionen:</strong><br>
        • Online-Banking und Banking-Apps<br>
        • Überweisungen und Kartenzahlungen<br>
        • Kredite und Kontoverwaltung<br>
        • Börsenhandel<br>
        • E-Mail und wichtige IT-Systeme<br><br>
        
        <strong>💡 Beispiele:</strong><br>
        ✅ Online-Banking länger als 1h offline<br>
        ✅ Kreditkarten werden abgelehnt<br>
        ✅ Geldautomaten ausgefallen<br>
        ✅ E-Mail funktioniert nicht<br>
        ❌ Interne Schulungs-Plattform offline
        `    },{
        id: 3,        title: "Entspricht der Vorfall zeitlichen Kriterien?",
        text: "Dauert die Störung schon länger als 1 Stunde?",
        additionalInfo: `
        <strong>⏰ Wichtige Zeitgrenzen:</strong><br><br>
        
        <strong>Wesentliche Störung (DORA):</strong><br>
        • Über 1 Stunde ohne Service bei kritischen Funktionen<br>
        • Über 2 Stunden bei wichtigen Funktionen<br><br>
        
        <strong>💡 Beispiele:</strong><br>
        ✅ Online-Banking seit 1,5h offline<br>
        ✅ Kartenzahlungen seit 3h gestört<br>
        ✅ Geldautomaten-Netz seit 2h ausgefallen<br>
        ❌ E-Mail war 45 Min offline<br>
        ❌ Website 30 Min langsam
        `
    },    {
        id: 4,        title: "Sind personenbezogene oder sensible Daten betroffen?",
        text: "Könnten persönliche Daten oder Geschäftsgeheimnisse betroffen sein?",
        additionalInfo: `
        <strong>🔒 Kritische Daten:</strong><br><br>
        
        <strong>Kundendaten:</strong><br>
        • Namen, Adressen, Geburtsdaten<br>
        • Kontostände, Überweisungen<br>
        • Logins, PINs, Passwörter<br><br>
        
        <strong>Geschäftsdaten:</strong><br>
        • Verträge und Geschäftsgeheimnisse<br>
        • E-Mails und Mitarbeiterdaten<br>
        • System-Zugangsdaten<br><br>
        
        <strong>💡 Beispiele:</strong><br>
        ✅ Hacker-Zugriff auf Kundendatenbank<br>
        ✅ USB-Stick mit Kontodaten verloren<br>
        ✅ E-Mail an falschen Empfänger<br>
        ✅ Ransomware verschlüsselt Dateien<br>
        ❌ Test-System ohne echte Daten
        `
    },    {
        id: 5,        title: "Sind externe IKT-Dienstleister oder Partner betroffen?",
        text: "Hat der Vorfall mit Cloud-Services oder IT-Dienstleistern zu tun?",
        additionalInfo: `
        <strong>☁️ Externe IT-Services:</strong><br><br>
        
        <strong>Cloud-Anbieter:</strong><br>
        • Microsoft 365, Google Cloud<br>
        • AWS, Azure Services<br>
        • Backup- und Speicher-Services<br><br>
        
        <strong>Banking-Services:</strong><br>
        • Zahlungsdienstleister<br>
        • Börsen-Anbindungen<br>
        • Kernbanksysteme<br>
        • Internet-Provider<br><br>
        
        <strong>💡 Beispiele:</strong><br>
        ✅ Microsoft 365 down → E-Mail gestört<br>
        ✅ AWS-Ausfall → Banking-App offline<br>
        ✅ Kreditkarten-Dienstleister gestört<br>
        ✅ Internet-Provider-Störung<br>
        ❌ Interne Kantine-Software
        `
    },    {
        id: 6,        title: "Besteht Verdacht auf Cyberangriff oder böswillige Aktivitäten?",
        text: "Siehst du Anzeichen für einen möglichen Cyberangriff?",
        additionalInfo: `
        <strong>⚠️ Verdachtsmomente:</strong><br><br>
        
        <strong>Technische Anzeichen:</strong><br>
        • Ungewöhnliche Netzwerk-Aktivitäten<br>
        • Neue unbekannte Dateien oder Programme<br>
        • Verschlüsselte oder veränderte Dateien<br>
        • Langsame Systeme ohne erkennbaren Grund<br><br>
        
        <strong>Angriffs-Arten:</strong><br>
        • Phishing-E-Mails oder betrügerische Anrufe<br>
        • Ransomware (Lösegeldforderung)<br>
        • DDoS-Angriffe (Website überlastet)<br>
        • Unberechtigte Logins oder Zugriffe<br><br>
        
        <strong>💡 Beispiele:</strong><br>
        ✅ Ransomware verschlüsselt Dateien<br>
        ✅ Phishing-E-Mail führt zu Datenverlust<br>
        ✅ Unbekannte Logins von fremden Standorten<br>
        ✅ DDoS macht Website unzugänglich<br>
        ❌ Zufälliger Hardware-Defekt
        `
    },
];

// Anwendungszustand
let currentQuestionIndex = 0;
let answers = [];
let isQuestionnaireStarted = false;

// Initialisierung
document.addEventListener('DOMContentLoaded', function() {
    showScreen('welcome-screen');
    setupEmailClickTracking();
});

// Screen-Management
function showScreen(screenId) {
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => screen.classList.remove('active'));
    
    const targetScreen = document.getElementById(screenId);
    if (targetScreen) {
        targetScreen.classList.add('active');
    }
}

// Fragebogen starten
function startQuestionnaire() {
    currentQuestionIndex = 0;
    answers = [];
    isQuestionnaireStarted = true;
    showQuestion();
    showScreen('question-screen');
}

// Frage anzeigen
function showQuestion() {
    if (currentQuestionIndex >= questions.length) {
        showResult();
        return;
    }

    const question = questions[currentQuestionIndex];
    const progressPercent = ((currentQuestionIndex + 1) / questions.length) * 100;
    
    // Progress Bar aktualisieren
    document.getElementById('progress-fill').style.width = progressPercent + '%';
    document.getElementById('progress-text').textContent = `Frage ${currentQuestionIndex + 1} von ${questions.length}`;
    
    // Frage-Inhalt aktualisieren
    document.getElementById('question-title').textContent = question.title;
    document.getElementById('question-text').textContent = question.text;
    
    // Zusätzliche Informationen
    const additionalInfo = document.getElementById('additional-info');
    if (question.additionalInfo) {
        additionalInfo.innerHTML = `<strong>💡 Zusätzliche Information:</strong><br>${question.additionalInfo}`;
        additionalInfo.style.display = 'block';
    } else {
        additionalInfo.style.display = 'none';
    }
    
    // Zurück-Button Status
    const backBtn = document.getElementById('back-btn');
    backBtn.disabled = currentQuestionIndex === 0;
}

// Antwort verarbeiten
function answerQuestion(answer) {
    answers[currentQuestionIndex] = answer;
    currentQuestionIndex++;
    
    if (currentQuestionIndex < questions.length) {
        showQuestion();
    } else {
        showResult();
    }
}

// Zurück-Navigation
function goBack() {
    if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        showQuestion();
    }
}

// Ergebnis berechnen und anzeigen
function showResult() {
    const resultContent = document.getElementById('result-content');
    const shouldReport = calculateResult();
    
    if (shouldReport) {
        resultContent.innerHTML = `
            <div class="result-danger">
                <h3>⚠️ Meldepflichtiger Vorfall erkannt</h3>
                <p><strong>Bitte informieren Sie Nikolas über diesen Vorfall.</strong></p>
                <p>Basierend auf Ihren Antworten handelt es sich möglicherweise um einen meldepflichtigen IKT-Vorfall nach DORA.</p>
                <div style="margin-top: 20px;">
                    <button class="btn btn-primary" onclick="showContact()">📞 Nikolas kontaktieren</button>
                </div>
            </div>
        `;
    } else {
        resultContent.innerHTML = `
            <div class="result-success">
                <h3>✅ Kein meldepflichtiger Vorfall</h3>
                <p><strong>Bitte dokumentieren Sie den Vorfall intern.</strong></p>
                <p>Basierend auf Ihren Antworten ist keine sofortige Meldung nach DORA erforderlich. Dokumentieren Sie den Vorfall dennoch für interne Zwecke.</p>
                <div class="additional-info" style="margin-top: 20px; text-align: left;">
                    <strong>📋 Empfohlene Maßnahmen:</strong><br>
                    • Vorfall in internem System dokumentieren<br>
                    • Ursachen analysieren<br>
                    • Präventive Maßnahmen prüfen<br>
                    • Bei Unsicherheit: IT-Abteilung kontaktieren
                </div>
            </div>
        `;
    }
    
    showScreen('result-screen');
}

// Ergebnis-Logik
function calculateResult() {
    // Wenn eine der kritischen Fragen mit "Ja" beantwortet wurde
    const criticalQuestions = [0, 3, 5]; // IKT-Systeme, Personendaten, Cyberangriff
    const moderateQuestions = [1, 2, 4]; // Geschäftsprozesse, Dauer, Externe Systeme
    
    // Kritische Fragen
    let criticalYes = 0;
    criticalQuestions.forEach(index => {
        if (answers[index] === true) criticalYes++;
    });
    
    // Moderate Fragen
    let moderateYes = 0;
    moderateQuestions.forEach(index => {
        if (answers[index] === true) moderateYes++;
    });
    
    // Bewertungslogik
    if (criticalYes >= 2) return true; // Zwei kritische Faktoren
    if (criticalYes >= 1 && moderateYes >= 2) return true; // Ein kritischer + zwei moderate
    if (answers[3] === true) return true; // Personendaten immer melden
    if (answers[5] === true) return true; // Cyberangriff immer melden
    
    return false;
}

// Kontakt-Screen anzeigen
function showContact() {
    showScreen('contact-screen');
}

// Fragebogen zurücksetzen
function resetQuestionnaire() {
    currentQuestionIndex = 0;
    answers = [];
    isQuestionnaireStarted = false;
    showScreen('welcome-screen');
    
    // Progress Bar zurücksetzen
    document.getElementById('progress-fill').style.width = '0%';
    document.getElementById('progress-text').textContent = 'Frage 1 von 6';
    
    // Erfolgsmeldung verstecken
    const successMessage = document.getElementById('success-message');
    if (successMessage) {
        successMessage.style.display = 'none';
    }
}

// E-Mail-Klick-Tracking für Erfolgsmeldung
function setupEmailClickTracking() {
    document.addEventListener('click', function(event) {
        if (event.target.matches('a[href^="mailto:"]')) {
            // Kurze Verzögerung, damit E-Mail-Client öffnen kann
            setTimeout(() => {
                const successMessage = document.getElementById('success-message');
                if (successMessage) {
                    successMessage.style.display = 'block';
                    successMessage.scrollIntoView({ behavior: 'smooth' });
                }
            }, 1000);
        }
    });
}

// Tastatur-Navigation
document.addEventListener('keydown', function(event) {
    if (!isQuestionnaireStarted) return;
    
    switch(event.key) {
        case 'y':
        case 'Y':
        case 'j':
        case 'J':
            if (document.getElementById('question-screen').classList.contains('active')) {
                answerQuestion(true);
            }
            break;
        case 'n':
        case 'N':
            if (document.getElementById('question-screen').classList.contains('active')) {
                answerQuestion(false);
            }
            break;
        case 'Escape':
            resetQuestionnaire();
            break;
        case 'Backspace':
            if (document.getElementById('question-screen').classList.contains('active')) {
                goBack();
            }
            break;
    }
});

// Accessibility: Focus-Management
function manageFocus() {
    const activeScreen = document.querySelector('.screen.active');
    if (activeScreen) {
        const firstButton = activeScreen.querySelector('button:not(:disabled)');
        if (firstButton) {
            firstButton.focus();
        }
    }
}

// Focus nach Screen-Wechsel setzen
const originalShowScreen = showScreen;
showScreen = function(screenId) {
    originalShowScreen(screenId);
    setTimeout(manageFocus, 100);
};

// Debugging-Funktionen (können in Produktion entfernt werden)
function getDebugInfo() {
    return {
        currentQuestion: currentQuestionIndex + 1,
        answers: answers,
        isStarted: isQuestionnaireStarted,
        result: isQuestionnaireStarted && currentQuestionIndex >= questions.length ? calculateResult() : null
    };
}

// Export für mögliche Tests
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        questions,
        calculateResult,
        getDebugInfo
    };
}
