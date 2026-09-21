#!/bin/bash

#
# Semantic Versioning Git Hook Script
# Automatisch Tags nach Semantic Versioning und Conventional Commits erstellen
#
# Conventional Commits:
#   - fix: patch version (+0.0.1)
#   - feat: minor version (+0.1.0)
#   - BREAKING CHANGE: major version (+1.0.0)
#

set -e

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging-Funktionen
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

# Aktuellsten Git Tag auslesen
get_latest_tag() {
    git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0"
}

# Version aus Tag extrahieren (z.B. "v1.2.3" -> "1.2.3")
extract_version() {
    local tag=$1
    echo "${tag#v}"  # Entfernt führendes 'v'
}

# Version in MAJOR, MINOR, PATCH zerlegen
parse_version() {
    local version=$1
    IFS='.' read -r major minor patch <<< "$version"
    echo "$major $minor $patch"
}

# Prüfe ob Commit Message mit Conventional Commit Format beginnt
get_commit_type() {
    local commit_msg=$1
    
    if [[ "$commit_msg" =~ ^BREAKING\ CHANGE ]]; then
        echo "BREAKING"
    elif [[ "$commit_msg" =~ ^feat(\(.+\))?!: ]]; then
        echo "BREAKING"
    elif [[ "$commit_msg" =~ ^feat(\(.+\))?:\ ]]; then
        echo "feat"
    elif [[ "$commit_msg" =~ ^fix(\(.+\))?:\ ]]; then
        echo "fix"
    elif [[ "$commit_msg" =~ ^docs(\(.+\))?:\ ]]; then
        echo "docs"
    elif [[ "$commit_msg" =~ ^style(\(.+\))?:\ ]]; then
        echo "style"
    elif [[ "$commit_msg" =~ ^refactor(\(.+\))?:\ ]]; then
        echo "refactor"
    elif [[ "$commit_msg" =~ ^perf(\(.+\))?:\ ]]; then
        echo "perf"
    elif [[ "$commit_msg" =~ ^test(\(.+\))?:\ ]]; then
        echo "test"
    else
        echo "other"
    fi
}

# Neue Version berechnen basierend auf Commit Typ
calculate_new_version() {
    local current_version=$1
    local commit_type=$2
    
    read -r major minor patch <<< "$(parse_version "$current_version")"
    
    case $commit_type in
        BREAKING)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        feat)
            minor=$((minor + 1))
            patch=0
            ;;
        fix|docs|style|refactor|perf|test)
            patch=$((patch + 1))
            ;;
        other)
            # Keine Versionierung für unbekannte Typen
            echo ""
            return
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Main Script
main() {
    log_info "Semantic Versioning Hook wird ausgeführt..."
    
    # Aktuelle Commit Message auslesen
    local commit_hash=$(git rev-parse HEAD)
    local commit_msg=$(git log -1 --pretty=%B "$commit_hash")
    local commit_subject=$(git log -1 --pretty=%s "$commit_hash")
    
    log_info "Commit: $commit_subject"
    
    # Aktuellsten Tag auslesen
    local latest_tag=$(get_latest_tag)
    local current_version=$(extract_version "$latest_tag")
    
    log_info "Aktueller Tag: $latest_tag (Version: $current_version)"
    
    # Commit Type bestimmen
    local commit_type=$(get_commit_type "$commit_msg")
    
    if [ "$commit_type" = "other" ]; then
        log_warn "Commit erfüllt nicht das Conventional Commits Format"
        log_warn "Kein neuer Tag wird erstellt"
        log_warn "Format: <type>(<scope>): <subject>"
        log_warn "Typen: feat, fix, docs, style, refactor, perf, test"
        return 0
    fi
    
    log_info "Commit Typ erkannt: $commit_type"
    
    # Neue Version berechnen
    local new_version=$(calculate_new_version "$current_version" "$commit_type")
    local new_tag="v$new_version"
    
    log_success "Neue Version: $new_version"
    
    # Neuen Tag erstellen
    if git tag -a "$new_tag" -m "Release $new_version"; then
        log_success "Tag erstellt: $new_tag"
        log_info "Tag Details:"
        log_info "  - Hash: $commit_hash"
        log_info "  - Message: $commit_subject"
        log_info "  - Typ: $commit_type"
        log_info "  - Alte Version: $current_version"
        log_info "  - Neue Version: $new_version"
    else
        log_error "Fehler beim Erstellen des Tags"
        exit 1
    fi
}

# Script ausführen
main
