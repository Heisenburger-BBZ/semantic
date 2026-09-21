#!/bin/bash

#
# Setup Script für Semantic Versioning Hooks
# Führt einmalige Konfiguration durch
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

main() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}Semantic Versioning Setup${NC}"
    echo -e "${BLUE}================================${NC}\n"
    
    # Prüfe ob Git-Repository existiert
    if [ ! -d .git ]; then
        log_error "Nicht in einem Git-Repository!"
        exit 1
    fi
    
    log_info "Git Repository erkannt"
    
    # 1. Dateiberechtigungen setzen
    log_info "Setze Dateiberechtigungen..."
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        log_info "Windows erkannt - Git Bash Berechtigungen"
        git update-index --chmod=+x .git/hooks/post-commit 2>/dev/null || true
        git update-index --chmod=+x scripts/semantic-versioning.sh 2>/dev/null || true
    else
        log_info "Unix-basiertes System erkannt"
        chmod +x .git/hooks/post-commit
        chmod +x scripts/semantic-versioning.sh
    fi
    log_success "Dateiberechtigungen gesetzt"
    
    # 2. Git Hooks Path konfigurieren
    log_info "Konfiguriere Git Hooks..."
    git config core.hooksPath .git/hooks
    log_success "Git Hooks Path konfiguriert: $(git config core.hooksPath)"
    
    # 3. Prüfe ob bereits Tags existieren
    local tag_count=$(git tag | wc -l)
    
    if [ $tag_count -eq 0 ]; then
        log_info "Keine Tags vorhanden - erstelle Initial-Tag v0.0.0"
        git tag -a v0.0.0 -m "Initial release"
        log_success "Initial-Tag erstellt: v0.0.0"
    else
        log_info "Existierende Tags: $(git tag | tr '\n' ', ' | sed 's/,$//')"
    fi
    
    # 4. Zusammenfassung
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}Setup abgeschlossen!${NC}"
    echo -e "${GREEN}================================${NC}\n"
    
    log_info "Konfiguration:"
    log_info "  - Hook-Pfad: $(git config core.hooksPath)"
    log_info "  - Hooks-Verzeichnis: $(pwd)/.git/hooks"
    log_info "  - Script: $(pwd)/scripts/semantic-versioning.sh"
    
    echo ""
    log_success "Der Post-Commit Hook ist jetzt aktiv!"
    log_success "Verwenden Sie Conventional Commits für automatisches Tagging"
    echo ""
    log_info "Beispiele:"
    log_info "  git commit -m 'feat(feature): neue Funktion'"
    log_info "  git commit -m 'fix(bug): Bug behoben'"
    log_info "  git commit -m 'feat(api)!: Breaking Change'"
    echo ""
}

main "$@"
