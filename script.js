// Fragebogen-Konfiguration
const questions = [    {
        id: 1,
        title: "Betrifft der Vorfall IKT-Systeme?",
        text: "Ist ein Informations- und Kommunikationstechnologie-System (Server, Netzwerk, Software, etc.) betroffen?",
        additionalInfo: `
        <strong>🔧 DORA-Definition (Art. 3 Nr. 2, 4):</strong><br>
        IKT-Systeme umfassen alle <em>Netzwerk- und Informationssysteme</em> zur Gewährleistung der digitalen operationellen Resilienz von Finanzunternehmen.<br><br>
        
        <strong>📊 Umfasst folgende Systemkategorien:</strong><br>
        • <strong>Hardware:</strong> Server, Computer, Netzwerkgeräte, Mobilgeräte, IoT-Geräte<br>
        • <strong>Software:</strong> Anwendungen, Betriebssysteme, Datenbanken, APIs, Middleware<br>
        • <strong>Netzwerke:</strong> LAN, WAN, Internet, VPN, Wireless-Verbindungen<br>
        • <strong>Cloud-Services:</strong> SaaS, PaaS, IaaS, Hybrid-Cloud-Architekturen<br>
        • <strong>Legacy-Systeme:</strong> Ältere Systeme am Ende des Lebenszyklus (Art. 3 Nr. 3)<br><br>
        
        <strong>⚠️ Besondere Beachtung:</strong><br>
        • Auch <em>partielle Beeinträchtigungen</em> können meldepflichtig sein<br>
        • <strong>Physische Schäden</strong> (Stromausfall, Überhitzung, Wasserschäden) gelten als IKT-Vorfälle<br>
        • <strong>Umweltbedingte Ausfälle</strong> (extreme Temperaturen, Naturkatastrophen)<br>
        • <strong>Indirekte Ausfälle</strong> durch Abhängigkeiten zu anderen Systemen<br><br>
        
        <strong>💡 Praxisbeispiele:</strong><br>
        ✅ Serverausfall im Rechenzentrum<br>
        ✅ Netzwerkstörung bei Internet-Banking<br>
        ✅ Software-Bug in Handelsplattform<br>
        ✅ Mobile App funktioniert nicht<br>
        ✅ E-Mail-System down<br>
        ✅ Backup-System defekt
        `
    },    {
        id: 2,
        title: "Sind kritische oder wichtige Geschäftsfunktionen betroffen?",
        text: "Beeinträchtigt der Vorfall Geschäftsabläufe, die für die Kernaktivitäten des Unternehmens essentiell sind?",
        additionalInfo: `
        <strong>🎯 DORA-Definition (Art. 3 Nr. 22):</strong><br>
        <em>"Kritische oder wichtige Funktionen"</em> sind solche, deren Störung die finanzielle Leistung, Solidität oder Kontinuität der Dienstleistungen erheblich beeinträchtigen würde.<br><br>
        
        <strong>🏦 Kerngeschäftsfunktionen (gem. Art. 2 Abs. 1):</strong><br>
        • <strong>Zahlungsverkehr:</strong> SEPA, Überweisungen, Kartenzahlungen, Instant Payments<br>
        • <strong>Kreditprozesse:</strong> Kreditvergabe, Bonitätsprüfung, Risikobeurteilung<br>
        • <strong>Handelsaktivitäten:</strong> Wertpapierhandel, Derivategeschäfte, Market Making<br>
        • <strong>Kundenportale:</strong> Online-Banking, Mobile Banking, Kontoverwaltung<br>
        • <strong>Clearing & Settlement:</strong> Abwicklung von Transaktionen<br><br>
        
        <strong>🔧 Support-Funktionen (können kritisch sein):</strong><br>
        • <strong>Risikomanagement:</strong> Risikomessung, Portfolioüberwachung, Stresstests<br>
        • <strong>Compliance:</strong> Regulatorische Meldungen, AML-Überwachung, GDPR<br>
        • <strong>Rechnungswesen:</strong> Buchhaltung, Bilanzierung, Controlling<br>
        • <strong>HR-Systeme:</strong> Mitarbeiterverwaltung, Gehaltsabrechnung (wenn zentral)<br>
        • <strong>Interne Kommunikation:</strong> E-Mail, Videokonferenzen, Collaboration Tools<br><br>
        
        <strong>⚖️ Bewertungskriterien:</strong><br>
        • <strong>Vollständiger Ausfall</strong> ist nicht erforderlich<br>
        • Bereits <em>erhebliche Verschlechterung</em> der Servicequalität kann ausreichen<br>
        • <strong>Kundenerfahrung:</strong> Können Kunden ihre gewohnten Services nutzen?<br>
        • <strong>Regulatorische Auswirkungen:</strong> Verstöße gegen Meldepflichten<br>
        • <strong>Reputationsrisiko:</strong> Öffentliche Wahrnehmung und Medienberichterstattung<br><br>
        
        <strong>💡 Praxisbeispiele:</strong><br>
        ✅ Online-Banking nicht erreichbar (> 1h)<br>
        ✅ Kreditkartenzahlungen werden abgelehnt<br>
        ✅ Trading-Platform down während Handelszeiten<br>
        ✅ ATM-Netzwerk großflächig ausgefallen<br>
        ✅ Regulatorische Meldungen können nicht erstellt werden<br>
        ❌ Interne Schulungsplattform offline (wenn nicht-kritisch)
        `
    },    {
        id: 3,
        title: "Dauert die Störung länger als 1 Stunde oder überschreitet Schwellenwerte?",
        text: "Ist die Beeinträchtigung bereits länger als eine Stunde aktiv oder werden quantitative Meldekrite rien erreicht?",
        additionalInfo: `
        <strong>⏰ DORA-Zeitkriterien (Art. 18, 19):</strong><br>
        Die ESAs entwickeln spezifische <em>Materialitätsschwellenwerte</em> für major IKT-related incidents (Art. 18 Abs. 3).<br><br>
        
        <strong>🕐 Zeitbasierte Kriterien:</strong><br>
        • <strong>Kritische Systeme:</strong> Bereits <em>1 Stunde Unterbrechung</em> kann meldepflichtig sein<br>
        • <strong>Service Downtime:</strong> Zeitraum der Nichtverfügbarkeit (Art. 18 Abs. 1 lit. b)<br>
        • <strong>Geographische Ausbreitung:</strong> Besonders bei >2 Mitgliedstaaten (Art. 18 Abs. 1 lit. c)<br>
        • <strong>Wiederherstellungszeit:</strong> Zeit bis zur vollständigen Funktionsfähigkeit<br><br>
        
        <strong>📊 Quantitative Schwellenwerte:</strong><br>
        • <strong>Anzahl betroffener Kunden:</strong> Abhängig von Institutsgröße<br>
        • <strong>Transaktionsvolumen:</strong> Wert der betroffenen Transaktionen<br>
        • <strong>Finanzielle Verluste:</strong> Direkte und indirekte Kosten<br>
        • <strong>Reputationsschäden:</strong> Medienberichterstattung, Social Media Impact<br>
        • <strong>Marktauswirkungen:</strong> Auswirkungen auf Marktintegrität<br><br>
        
        <strong>⏳ Effektive Störungsdauer umfasst:</strong><br>
        • <strong>Nachwirkungen:</strong> Datenverluste, Performance-Probleme<br>
        • <strong>Manuelle Workarounds:</strong> Aufwendige alternative Prozesse<br>
        • <strong>Präventive Abschaltungen:</strong> Zur Schadensbegrenzung<br>
        • <strong>Wiederanlauf-Probleme:</strong> Instabile Systeme nach Wiederherstellung<br>
        • <strong>Datenintegrität-Prüfungen:</strong> Validierung nach Störung<br><br>
        
        <strong>📈 Sektorspezifische Kriterien (Art. 20):</strong><br>
        • <strong>Kreditinstitute:</strong> Fokus auf Zahlungsverkehr und Kreditprozesse<br>
        • <strong>Wertpapierfirmen:</strong> Handelszeiten und Marktzeiten kritisch<br>
        • <strong>Versicherungen:</strong> Schadensmeldungen und Policenverwaltung<br>
        • <strong>Zentrale Kontrahenten:</strong> Settlement-Vorgänge<br><br>
        
        <strong>⚠️ Besondere Situationen:</strong><br>
        • <strong>Kaskadeneffekte:</strong> Störung breitet sich auf andere Systeme aus<br>
        • <strong>Spitzenzeiten:</strong> Erhöhte Kritikalität während High-Load-Perioden<br>
        • <strong>Regulatorische Deadlines:</strong> Meldetermine, Reporting-Zyklen<br><br>
        
        <strong>💡 Praxisbeispiele:</strong><br>
        ✅ Online-Banking 2h offline → Meldepflichtig<br>
        ✅ 10.000+ Kunden können nicht auf Konten zugreifen<br>
        ✅ Überweisungen >5 Mio EUR nicht möglich<br>
        ✅ Trading-Stopp während Börsenschluss<br>
        ❌ Interne Schulungsplattform 3h offline<br>
        ❌ Test-System außerhalb Geschäftszeiten down
        `
    },    {
        id: 4,
        title: "Sind personenbezogene oder sensible Daten betroffen?",
        text: "Könnten personenbezogene Daten, Geschäftsgeheimnisse oder vertrauliche Informationen kompromittiert worden sein?",
        additionalInfo: `
        <strong>🔒 DORA & DSGVO-Nexus (Art. 3 Nr. 8, Art. 19):</strong><br>
        IKT-related incidents mit Datenbezug unterliegen sowohl DORA- als auch DSGVO-Meldepflichten.<br><br>
        
        <strong>👤 Personenbezogene Daten (DSGVO Art. 4):</strong><br>
        • <strong>Kundendaten:</strong> Namen, Adressen, Geburtsdaten, Steuer-IDs<br>
        • <strong>Finanzdaten:</strong> Kontostände, Transaktionshistorie, Kreditscores<br>
        • <strong>Authentifizierungsdaten:</strong> Logins, PINs, biometrische Daten<br>
        • <strong>Mitarbeiterdaten:</strong> HR-Records, Gehaltsdaten, Leistungsbeurteilungen<br>
        • <strong>Kommunikationsdaten:</strong> E-Mails, Chat-Protokolle, Telefonnotizen<br><br>
        
        <strong>🏢 Geschäftskritische Daten:</strong><br>
        • <strong>Handelsgeheimnisse:</strong> Algorithmen, Pricing-Modelle, Strategien<br>
        • <strong>Regulatorische Daten:</strong> Meldungen, Compliance-Reports, Audit-Trails<br>
        • <strong>Konfigurationsdaten:</strong> System-Settings, Zugangsdaten, API-Keys<br>
        • <strong>Risikodaten:</strong> Portfolios, Exposures, Stress-Test-Ergebnisse<br>
        • <strong>Vertragsunterlagen:</strong> Kreditverträge, Versicherungspolicen<br><br>
        
        <strong>⚠️ Arten der Datenkompromittierung:</strong><br>
        • <strong>Unbefugter Zugriff:</strong> Hacker, Insider-Bedrohungen, Social Engineering<br>
        • <strong>Datenverlust:</strong> Löschung, Korruption, Hardware-Defekte<br>
        • <strong>Datendiebstahl:</strong> Exfiltration, Kopieren, Screenshots<br>
        • <strong>Unbeabsichtigte Offenlegung:</strong> Fehlgeleitete E-Mails, falsche Berechtigungen<br>
        • <strong>Datenveränderung:</strong> Manipulation, Verfälschung, Ransomware-Verschlüsselung<br>
        • <strong>Verfügbarkeitsverlust:</strong> Backups defekt, Systeme nicht erreichbar<br><br>
        
        <strong>🔍 Verdachtsindikatoren:</strong><br>
        • <strong>Anomale Zugriffsmuster:</strong> Ungewöhnliche Login-Zeiten/-Orte<br>
        • <strong>Systemalarme:</strong> DLP-Alerts, SIEM-Warnungen, Antivirus-Meldungen<br>
        • <strong>Performance-Anomalien:</strong> Langsame Datenbankabfragen, Netzwerk-Spikes<br>
        • <strong>Unbekannte Dateien:</strong> Neue Dateien, verschlüsselte Files, verdächtige Extensions<br>
        • <strong>Benutzerberichte:</strong> Kunden melden fremde Transaktionen<br><br>
        
        <strong>☁️ Cloud & Drittanbieter-Risiken:</strong><br>
        • <strong>Multi-Tenancy:</strong> Andere Mandanten im gleichen System betroffen<br>
        • <strong>Jurisdiktionale Risiken:</strong> Daten in Drittländern, unterschiedliche Rechtslage<br>
        • <strong>Supplier-Incidents:</strong> Datenlecks bei Cloud-Anbietern<br>
        • <strong>Übertragungsrisiken:</strong> Man-in-the-Middle-Angriffe, unsichere APIs<br><br>
        
        <strong>⏰ Meldepflichten (Doppelmeldung):</strong><br>
        • <strong>DSGVO:</strong> 72h an Datenschutzbehörde + ggf. Betroffene (Art. 33/34)<br>
        • <strong>DORA:</strong> Initial notification + intermediate + final report (Art. 19)<br>
        • <strong>Koordination:</strong> Konsistente Kommunikation zwischen beiden Verfahren<br><br>
        
        <strong>💡 Praxisbeispiele:</strong><br>
        ✅ Hacker-Zugriff auf Kundendatenbank<br>
        ✅ E-Mail mit Kontodaten an falschen Empfänger<br>
        ✅ Ransomware verschlüsselt Kreditakten<br>
        ✅ USB-Stick mit Gehaltsdaten verloren<br>
        ✅ Online-Banking zeigt fremde Kontostände<br>
        ✅ Backup-Tapes gestohlen<br>
        ❌ Anonymisierte Testdaten ohne Personenbezug
        `
    },    {
        id: 5,
        title: "Sind externe IKT-Dienstleister oder Partner betroffen?",
        text: "Betrifft der Vorfall Cloud-Services, IT-Dienstleister oder könnte er sich auf Geschäftspartner auswirken?",
        additionalInfo: `
        <strong>🌐 DORA-Fokus auf Drittanbieter-Risiken (Art. 28-44):</strong><br>
        Kapitel V etabliert ein umfassendes <em>Oversight Framework</em> für kritische IKT-Drittdienstleister.<br><br>
        
        <strong>☁️ Cloud- und IKT-Dienstleister:</strong><br>
        • <strong>Hyperscaler:</strong> AWS, Microsoft Azure, Google Cloud Platform<br>
        • <strong>SaaS-Provider:</strong> Salesforce, Office 365, SAP Cloud-Lösungen<br>
        • <strong>Rechenzentren:</strong> Colocation-Provider, Housing-Services<br>
        • <strong>Netzwerk-Provider:</strong> Internet-Provider, MPLS-Netze, CDNs<br>
        • <strong>Security-Services:</strong> Firewall-as-a-Service, SIEM-Provider, SOCs<br><br>
        
        <strong>🏦 Finanzmarkt-spezifische Dienstleister:</strong><br>
        • <strong>Payment-Processors:</strong> Kreditkartenabwicklung, SEPA-Clearing<br>
        • <strong>Trading-Infrastruktur:</strong> Börsenanbindung, Market Data Feeds<br>
        • <strong>Core-Banking-Provider:</strong> Kernbanksysteme, Kontoverwaltung<br>
        • <strong>Compliance-Tools:</strong> AML-Software, Regulatory Reporting<br>
        • <strong>Risk Management:</strong> Portfolio-Tools, Risikocalculation-Engines<br><br>
        
        <strong>🔗 Lieferketten-Effekte (Art. 29):</strong><br>
        • <strong>Kaskadenausfälle:</strong> Ein Anbieter → mehrere Finanzinstitute betroffen<br>
        • <strong>Systemische Risiken:</strong> Too-big-to-fail bei IKT-Providern<br>
        • <strong>Konzentrations-Risiken:</strong> Viele Institute nutzen gleichen Provider<br>
        • <strong>Subkontraktor-Ketten:</strong> Sub-Sub-Dienstleister, komplexe Abhängigkeiten<br>
        • <strong>Cross-Border-Risiken:</strong> Internationale Verflechtungen<br><br>
        
        <strong>🌍 Geographische & Jurisdiktionale Aspekte:</strong><br>
        • <strong>Drittländer:</strong> Besondere Anforderungen (Art. 31 Abs. 12)<br>
        • <strong>Datenlokalisierung:</strong> Wo werden Daten verarbeitet/gespeichert?<br>
        • <strong>Politische Risiken:</strong> Handelsstreitigkeiten, Sanktionen<br>
        • <strong>Rechtsdurchsetzung:</strong> Effektive Aufsicht über ausländische Provider<br>
        • <strong>Business Continuity:</strong> Alternative Provider in anderen Regionen<br><br>
        
        <strong>🔍 Kritische IKT-Drittdienstleister (Art. 31):</strong><br>
        • <strong>Designation:</strong> ESAs bestimmen kritische Provider<br>
        • <strong>Lead Overseer:</strong> Direkte Aufsicht durch EU-Behörden<br>
        • <strong>Oversight Framework:</strong> Comprehensive Überwachung<br>
        • <strong>Subsidiary-Pflicht:</strong> EU-Niederlassung bei Drittland-Providern<br><br>
        
        <strong>⚠️ Incident-Auswirkungen bewerten:</strong><br>
        • <strong>Direkte Betroffenheit:</strong> Services des Providers ausgefallen<br>
        • <strong>Indirekte Auswirkungen:</strong> Performance-Degradation, Latenz<br>
        • <strong>Ansteckungsrisiko:</strong> Weitere Provider/Institute gefährdet<br>
        • <strong>Recovery-Abhängigkeiten:</strong> Wiederherstellung nur mit Provider möglich<br>
        • <strong>Exit-Szenarien:</strong> Notwendigkeit des Provider-Wechsels<br><br>
        
        <strong>📋 Contractual Obligations (Art. 30):</strong><br>
        • <strong>Incident Response:</strong> Provider muss bei Störungen unterstützen<br>
        • <strong>Notification Duties:</strong> Rechtzeitige Informationspflichten<br>
        • <strong>Audit Rights:</strong> Überprüfungsrechte der Finanzinstitute<br>
        • <strong>Exit Rights:</strong> Beendigungsrechte bei schweren Vorfällen<br><br>
        
        <strong>💡 Praxisbeispiele:</strong><br>
        ✅ AWS-Outage betrifft Core-Banking<br>
        ✅ Microsoft 365 down → E-Mail-Verkehr gestört<br>
        ✅ Payment-Processor-Ausfall → Kartenzahlungen unmöglich<br>
        ✅ Internet-Provider-Störung → Filialen offline<br>
        ✅ Trading-Platform-Provider down → Börsenhandel gestört<br>
        ✅ Backup-Service-Provider kompromittiert<br>
        ❌ Interne Kantine-Software (nicht geschäftskritisch)
        `
    },    {
        id: 6,
        title: "Besteht Verdacht auf Cyberangriff oder böswillige Aktivitäten?",
        text: "Gibt es Anzeichen für einen möglichen Cyberangriff, Malware, Social Engineering oder anderen böswilligen Zugriff?",
        additionalInfo: `
        <strong>🎯 DORA-Definition (Art. 3 Nr. 12-15):</strong><br>
        <em>Cyber-attacks</em> sind böswillige IKT-related incidents zur Zerstörung, Offenlegung oder unbefugten Zugriff auf Assets.<br><br>
        
        <strong>🔍 Technische Angriffsindikatoren:</strong><br>
        • <strong>Netzwerk-Anomalien:</strong> Ungewöhnlicher Traffic, Data Exfiltration, Command & Control<br>
        • <strong>Malware-Signaturen:</strong> Viren, Trojaner, Ransomware, Keylogger<br>
        • <strong>Systemveränderungen:</strong> Neue Benutzer, geänderte Berechtigungen, Registry-Modifikationen<br>
        • <strong>Unbekannte Prozesse:</strong> Neue Services, verdächtige Executables, Memory Injections<br>
        • <strong>Kryptographische Anomalien:</strong> Ungewöhnliche Verschlüsselung, Zertifikatsprobleme<br><br>
        
        <strong>🕵️ Behaviorale Indikatoren:</strong><br>
        • <strong>Login-Anomalien:</strong> Zugriffe außerhalb Geschäftszeiten, ungewöhnliche Standorte<br>
        • <strong>Privilege Escalation:</strong> Normale User mit Admin-Rechten<br>
        • <strong>Lateral Movement:</strong> Zugriffe auf untypische Systeme/Daten<br>
        • <strong>Data Harvesting:</strong> Massendownloads, systematische Datensammlung<br>
        • <strong>Account Abuse:</strong> Shared Accounts, Passwort-Spraying, Brute Force<br><br>
        
        <strong>🎣 Social Engineering & Human Factor:</strong><br>
        • <strong>Phishing:</strong> Gefälschte E-Mails, Credential Harvesting, CEO Fraud<br>
        • <strong>Spear Phishing:</strong> Gezielte Angriffe auf spezifische Mitarbeiter<br>
        • <strong>Pretexting:</strong> Falsche Identitäten am Telefon, gefälschte Support-Anfragen<br>
        • <strong>Baiting:</strong> Infizierte USB-Sticks, Downloads, QR-Codes<br>
        • <strong>Business Email Compromise:</strong> Kompromittierte E-Mail-Accounts<br><br>
        
        <strong>⚡ Advanced Persistent Threats (APT):</strong><br>
        • <strong>Multi-Stage-Angriffe:</strong> Langfristige, koordinierte Kampagnen<br>
        • <strong>Zero-Day-Exploits:</strong> Unbekannte Schwachstellen ausgenutzt<br>
        • <strong>Living-off-the-Land:</strong> Legitime Tools für böswillige Zwecke<br>
        • <strong>State-Sponsored:</strong> Nation-State-Akteure, Cyber-Warfare<br>
        • <strong>Supply Chain Attacks:</strong> Kompromittierung über Drittanbieter<br><br>
        
        <strong>🏴‍☠️ Ransomware & Erpressung:</strong><br>
        • <strong>Dateiverschlüsselung:</strong> Daten nicht mehr zugänglich<br>
        • <strong>Lösegeldforderungen:</strong> Zahlungsaufforderungen in Kryptowährung<br>
        • <strong>Double Extortion:</strong> Verschlüsselung + Datendiebstahl<br>
        • <strong>Triple Extortion:</strong> + DDoS-Angriffe, Kundenkontakt<br>
        • <strong>Ransomware-as-a-Service:</strong> Professionelle Banden, Affiliate-Programme<br><br>
        
        <strong>🌊 DDoS & Verfügbarkeitsangriffe:</strong><br>
        • <strong>Volumetrische Angriffe:</strong> Bandbreiten-Überlastung<br>
        • <strong>Protokoll-Angriffe:</strong> TCP SYN Floods, Ping of Death<br>
        • <strong>Application-Layer:</strong> HTTP Floods, Slowloris<br>
        • <strong>Botnet-gestützt:</strong> Koordinierte Angriffe von kompromittierten Geräten<br><br>
        
        <strong>⚠️ Besondere Bewertungskriterien:</strong><br>
        • <strong>Auch erfolglose Versuche</strong> können meldepflichtig sein<br>
        • <strong>Systematische Angriffe:</strong> Hinweise auf größere Kampagnen<br>
        • <strong>Schwachstellen-Aufdeckung:</strong> Attack zeigt Sicherheitslücken auf<br>
        • <strong>Threat Intelligence:</strong> Bekannte TTPs (Tactics, Techniques, Procedures)<br>
        • <strong>Forensische Evidenz:</strong> Digitale Beweismittel für Strafverfolgung<br><br>
        
        <strong>🚨 Immediate Response Indicators:</strong><br>
        • <strong>Isolation notwendig:</strong> Systeme müssen vom Netz getrennt werden<br>
        • <strong>Forensik erforderlich:</strong> Beweismittel sichern, Chain of Custody<br>
        • <strong>Law Enforcement:</strong> Strafverfolgung einschalten<br>
        • <strong>Threat Hunting:</strong> Proaktive Suche nach weiteren Kompromittierungen<br><br>
        
        <strong>💡 Praxisbeispiele:</strong><br>
        ✅ Ransomware verschlüsselt Server<br>
        ✅ Phishing-E-Mail führt zu Credential Theft<br>
        ✅ DDoS-Angriff macht Online-Banking unzugänglich<br>
        ✅ APT exfiltriert Kundendaten über Monate<br>
        ✅ Insider verkauft Kontodaten<br>
        ✅ CEO-Fraud führt zu Überweisungsbetrug<br>
        ✅ Supply Chain Attack über Software-Update<br>
        ❌ Zufälliger Hardware-Defekt ohne böswillige Absicht
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
