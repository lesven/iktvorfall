// Fragebogen-Konfiguration
const questions = [
    {
        id: 1,
        title: "Betrifft der Vorfall IKT-Systeme?",
        text: "Ist ein Informations- und Kommunikationstechnologie-System (Server, Netzwerk, Software, etc.) betroffen?",
        additionalInfo: "Nach DORA gelten als IKT-Systeme alle digitalen und technischen Komponenten der IT-Infrastruktur: Hardware (Server, Computer, Netzwerkgeräte), Software (Anwendungen, Betriebssysteme, Datenbanken), Netzwerke (LAN, WAN, Internet), Cloud-Services und mobile Endgeräte. Auch kleinere Ausfälle können bei kritischen Systemen meldepflichtig sein, wenn sie die Geschäftstätigkeit beeinträchtigen. Physische Schäden an IT-Komponenten durch Stromausfall, Überhitzung oder andere Umwelteinflüsse fallen ebenfalls unter IKT-Vorfälle."
    },
    {
        id: 2,
        title: "Sind kritische oder wichtige Geschäftsfunktionen betroffen?",
        text: "Beeinträchtigt der Vorfall Geschäftsabläufe, die für die Kernaktivitäten des Unternehmens essentiell sind?",
        additionalInfo: "DORA definiert 'kritische oder wichtige Funktionen' als Geschäftstätigkeiten, deren Störung die Finanzleistung, Solidität oder Kontinuität der Dienstleistungen erheblich beeinträchtigen würde. Bei Finanzdienstleistern umfasst dies: Zahlungsverkehr, Kreditvergabe, Handelsaktivitäten, Kundenportale, Risikomanagement-Systeme, regulatorische Berichterstattung und Compliance-Systeme. Auch Support-Funktionen wie Buchhaltung, HR-Systeme oder interne Kommunikation können kritisch sein, wenn sie zentrale Geschäftsprozesse unterstützen. Der Ausfall muss nicht vollständig sein - bereits eine erhebliche Verschlechterung der Servicequalität kann meldepflichtig sein."
    },
    {
        id: 3,
        title: "Dauert die Störung länger als 1 Stunde oder überschreitet Schwellenwerte?",
        text: "Ist die Beeinträchtigung bereits länger als eine Stunde aktiv oder werden quantitative Meldekrite rien erreicht?",
        additionalInfo: "DORA legt verschiedene Zeitkritereien fest: Bei kritischen Systemen kann bereits eine einstündige Unterbrechung meldepflichtig sein. Zusätzlich gibt es quantitative Schwellenwerte basierend auf der Anzahl betroffener Kunden, Transaktionsvolumen oder finanziellen Verlusten. Auch wenn die ursprüngliche Störung behoben ist, aber Nachwirkungen bestehen (z.B. Datenverluste, Performance-Probleme, notwendige manuelle Workarounds), kann dies die effektive Störungsdauer verlängern. Präventive Systemabschaltungen zur Schadensbegrenzung zählen ebenfalls zur Ausfallzeit."
    },
    {
        id: 4,
        title: "Sind personenbezogene oder sensible Daten betroffen?",
        text: "Könnten personenbezogene Daten, Geschäftsgeheimnisse oder vertrauliche Informationen kompromittiert worden sein?",
        additionalInfo: "Nach DORA und DSGVO sind alle Vorfälle meldepflichtig, die personenbezogene Daten gefährden: unbefugter Zugriff (auch Verdachtsfälle), Datenverlust, Diebstahl, unbeabsichtigte Offenlegung, Veränderung oder Zerstörung von Daten. Dies umfasst: Kundendaten (Namen, Adressen, Finanzdaten), Mitarbeiterdaten, Transaktionsdaten, Kreditinformationen und interne Geschäftsdaten. Auch technische Daten wie Zugangsdaten, Konfigurationsdateien oder Systemlogs können sensibel sein. Bereits der Verdacht einer Kompromittierung (z.B. durch ungewöhnliche Zugriffsmuster, verdächtige Logins oder Systemalarme) kann eine Meldung rechtfertigen. Bei Cloud-Systemen müssen auch potentielle Datenlecks bei Drittanbietern berücksichtigt werden."
    },
    {
        id: 5,
        title: "Sind externe IKT-Dienstleister oder Partner betroffen?",
        text: "Betrifft der Vorfall Cloud-Services, IT-Dienstleister oder könnte er sich auf Geschäftspartner auswirken?",
        additionalInfo: "DORA legt besonderen Fokus auf IKT-Drittdienstleister-Risiken. Meldepflichtig sind Vorfälle bei: Cloud-Anbietern (AWS, Microsoft Azure, Google Cloud), Software-as-a-Service Providern, Rechenzentren, Telekommunikationsanbietern, Payment-Processorns und anderen IT-Outsourcing-Partnern. Auch Lieferketteneffekte sind relevant: Störungen bei einem Dienstleister können mehrere Finanzinstitute gleichzeitig betreffen und systemische Risiken schaffen. Bei grenzüberschreitenden Dienstleistern können verschiedene Aufsichtsbehörden betroffen sein. Wichtig ist auch die Bewertung von Abhängigkeiten: Fallen mehrere kritische Services gleichzeitig aus, oder könnte ein Vorfall auf andere Systeme übergreifen? Subunternehmer und deren Sicherheitsvorfälle müssen ebenfalls berücksichtigt werden."
    },
    {
        id: 6,
        title: "Besteht Verdacht auf Cyberangriff oder böswillige Aktivitäten?",
        text: "Gibt es Anzeichen für einen möglichen Cyberangriff, Malware, Social Engineering oder anderen böswilligen Zugriff?",
        additionalInfo: "Cyberangriffe sind nach DORA grundsätzlich meldepflichtig, da sie erhebliche operative Risiken darstellen. Indizien für böswillige Aktivitäten: ungewöhnliche Netzwerkaktivitäten, verdächtige E-Mails oder Phishing-Versuche, unerklärliche Systemverlangsamungen, unbekannte Dateien oder Prozesse, unautori sierte Änderungen an Systemkonfigurationen, Anomalien in Logdateien, Erpressungsmeldungen (Ransomware), DDoS-Angriffe, ungewöhnliche Datentransfers, verdächtige Benutzeranmeldungen außerhalb der Geschäftszeiten oder von ungewöhnlichen Standorten. Auch erfolglose Angriffsversuche können meldepflichtig sein, wenn sie auf systematische Angriffe hindeuten oder Schwachstellen aufdecken. Social Engineering-Angriffe, bei denen Mitarbeiter zur Preisgabe von Zugangsdaten verleitet werden, fallen ebenfalls in diese Kategorie. Bei Verdacht sollte sofort eine forensische Untersuchung eingeleitet werden."
    }
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
