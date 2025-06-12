// Dieses Skript verhindert Browser-Caching durch mehrere Techniken
const BUILD_TIMESTAMP = new Date().toISOString();
console.log('App Version geladen: ' + BUILD_TIMESTAMP);

// Cache-Busting-Funktionen
(function() {
    // Generiere eine eindeutige Session-ID
    const sessionId = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    console.log('Cache-Busting Session ID: ' + sessionId);
    
    // 1. Service Worker deregistrieren (falls vorhanden)
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.getRegistrations().then(function(registrations) {
            for (let registration of registrations) {
                registration.unregister();
                console.log('Service Worker deregistriert');
            }
        });
    }
    
    // 2. Cache-Header direkt setzen
    function setNoCacheHeaders() {
        try {
            // Versuche, Cache-Control-Header per JavaScript zu setzen
            // (funktioniert in den meisten Fällen nicht direkt, aber schadet nicht)
            if (typeof window.headers !== 'undefined') {
                window.headers.set('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0');
                window.headers.set('Pragma', 'no-cache');
                window.headers.set('Expires', '0');
            }
            
            // Für ältere Browser: Meta-Tags überprüfen und ggf. hinzufügen
            const metaTags = document.getElementsByTagName('meta');
            let hasCacheControl = false;
            let hasPragma = false;
            let hasExpires = false;
            
            for (let i = 0; i < metaTags.length; i++) {
                const tag = metaTags[i];
                if (tag.httpEquiv === 'Cache-Control') hasCacheControl = true;
                if (tag.httpEquiv === 'Pragma') hasPragma = true;
                if (tag.httpEquiv === 'Expires') hasExpires = true;
            }
            
            // Fehlende Meta-Tags hinzufügen
            if (!hasCacheControl) {
                const meta = document.createElement('meta');
                meta.httpEquiv = 'Cache-Control';
                meta.content = 'no-cache, no-store, must-revalidate';
                document.head.appendChild(meta);
            }
            if (!hasPragma) {
                const meta = document.createElement('meta');
                meta.httpEquiv = 'Pragma';
                meta.content = 'no-cache';
                document.head.appendChild(meta);
            }
            if (!hasExpires) {
                const meta = document.createElement('meta');
                meta.httpEquiv = 'Expires';
                meta.content = '0';
                document.head.appendChild(meta);
            }
        } catch (e) {
            console.log('Fehler beim Setzen der Cache-Header:', e);
        }
    }
    
    // 3. Beim Zurück-Button immer neu laden
    window.addEventListener('pageshow', function(event) {
        if (event.persisted) {
            console.log('Seite aus Cache geladen (bfcache) - erzwinge Neuladen');
            window.location.reload();
        }
    });
    
    // 4. Alle Ressourcen dynamisch nachladen mit Cache-Buster
    function addCacheBusterToResources() {
        try {
            // CSS-Links mit Cache-Buster versehen
            const cssLinks = document.querySelectorAll('link[rel="stylesheet"]');
            for (let i = 0; i < cssLinks.length; i++) {
                const link = cssLinks[i];
                if (link.href && link.href.indexOf('?') === -1) {
                    link.href = link.href + '?nocache=' + sessionId;
                }
            }
            
            // Script-Tags mit Cache-Buster versehen (außer version.js selbst)
            const scriptTags = document.querySelectorAll('script[src]');
            for (let i = 0; i < scriptTags.length; i++) {
                const script = scriptTags[i];
                if (script.src && script.src.indexOf('?') === -1 && script.src.indexOf('version.js') === -1) {
                    script.src = script.src + '?nocache=' + sessionId;
                }
            }
            
            // Bilder mit Cache-Buster versehen
            const images = document.querySelectorAll('img');
            for (let i = 0; i < images.length; i++) {
                const img = images[i];
                if (img.src && img.src.indexOf('?') === -1) {
                    img.src = img.src + '?nocache=' + sessionId;
                }
            }
        } catch (e) {
            console.log('Fehler beim Hinzufügen von Cache-Bustern zu Ressourcen:', e);
        }
    }
    
    // 5. Lokalen Storage für die Version verwenden
    function checkVersion() {
        const currentVersion = localStorage.getItem('appVersion');
        const newVersion = new Date().toISOString();
        
        if (currentVersion !== newVersion) {
            localStorage.setItem('appVersion', newVersion);
            console.log('Neue Version erkannt, Cache wird geleert');
            
            // Versuche, Browser-Cache zu leeren
            if (window.location.reload && window.location.reload.length === 0) {
                window.location.reload(true);
            }
        }
    }
    
    // Funktionen ausführen
    setNoCacheHeaders();
    
    // Warte, bis das DOM geladen ist
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            addCacheBusterToResources();
            checkVersion();
        });
    } else {
        addCacheBusterToResources();
        checkVersion();
    }
})();
