#!/bin/bash
# IKT-Vorfall Docker Helper for Linux/macOS

function show_menu {
    clear
    echo "=== IKT-Vorfall Docker Management ==="
    echo "1: Container starten"
    echo "2: Container stoppen"
    echo "3: Container-Status anzeigen"
    echo "4: Logs anzeigen"
    echo "5: Container neu bauen und starten"
    echo "Q: Beenden"
}

function start_container {
    echo -e "\nStarte IKT-Vorfall Container..."
    docker-compose up -d
    
    echo -e "\nDie Anwendung ist jetzt unter http://localhost:8080 verfügbar."
    echo "Drücke eine Taste zum Fortfahren..."
    read -n 1
}

function stop_container {
    echo -e "\nStoppe IKT-Vorfall Container..."
    docker-compose down
    
    echo -e "\nContainer wurden gestoppt."
    echo "Drücke eine Taste zum Fortfahren..."
    read -n 1
}

function show_status {
    echo -e "\nAktueller Container-Status:"
    docker-compose ps
    
    echo -e "\nDrücke eine Taste zum Fortfahren..."
    read -n 1
}

function show_logs {
    echo -e "\nContainer-Logs:"
    docker-compose logs
    
    echo -e "\nDrücke eine Taste zum Fortfahren..."
    read -n 1
}

function rebuild_container {
    echo -e "\nContainer werden neu gebaut..."
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    
    echo -e "\nContainer wurden neu gebaut und gestartet."
    echo "Die Anwendung ist jetzt unter http://localhost:8080 verfügbar."
    echo "Drücke eine Taste zum Fortfahren..."
    read -n 1
}

# Main program
while true; do
    show_menu
    echo -e "\nWähle eine Option:"
    read choice
    
    case $choice in
        1) start_container ;;
        2) stop_container ;;
        3) show_status ;;
        4) show_logs ;;
        5) rebuild_container ;;
        [Qq]) exit 0 ;;
        *) 
            echo -e "\nUngültige Eingabe!"
            sleep 2
            ;;
    esac
done
