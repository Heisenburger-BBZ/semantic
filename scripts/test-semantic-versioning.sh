#!/bin/bash

#
# Test & Debug Script für Semantic Versioning Hook
# Simulates verschiedene Commit-Szenarien
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEMANTIC_SCRIPT="$SCRIPT_DIR/semantic-versioning.sh"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_test() {
    echo -e "${YELLOW}[TEST]${NC} $1"
}

log_result() {
    echo -e "${GREEN}[RESULT]${NC} $1"
}

# Test verschiedene Commit Typen
test_commit_type() {
    local commit_type=$1
    local test_message=$2
    
    log_test "Testing: $commit_type"
    log_info "Message: $test_message"
    
    # Erstelle Test Commit
    echo "Test content for $commit_type" >> test_file.tmp
    git add test_file.tmp
    git commit -m "$test_message" 2>&1 | head -5
    
    # Zeige neuen Tag
    local latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "none")
    log_result "Latest tag: $latest_tag"
    echo ""
}

# Parsing Test
test_parsing() {
    local message=$1
    
    log_test "Parsing: $message"
    
    # Extrahiere Typ
    if [[ "$message" =~ ^BREAKING\ CHANGE ]]; then
        log_result "Type detected: BREAKING"
    elif [[ "$message" =~ ^feat(\(.+\))?!: ]]; then
        log_result "Type detected: BREAKING (feat!)"
    elif [[ "$message" =~ ^feat(\(.+\))?:\ ]]; then
        log_result "Type detected: feat"
    elif [[ "$message" =~ ^fix(\(.+\))?:\ ]]; then
        log_result "Type detected: fix"
    elif [[ "$message" =~ ^docs(\(.+\))?:\ ]]; then
        log_result "Type detected: docs"
    else
        log_result "Type detected: other (no version bump)"
    fi
    echo ""
}

# Version Calculation Test
test_version_calculation() {
    local current_version=$1
    local commit_type=$2
    
    log_test "Version calculation: $current_version + $commit_type"
    
    IFS='.' read -r major minor patch <<< "$current_version"
    
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
        fix|docs|style)
            patch=$((patch + 1))
            ;;
    esac
    
    log_result "New version: $major.$minor.$patch"
    echo ""
}

# Main Menu
show_menu() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}Semantic Versioning Test Suite${NC}"
    echo -e "${BLUE}================================${NC}\n"
    
    echo "1. Test Parsing verschiedener Commit Types"
    echo "2. Test Versionsberechnung"
    echo "3. Hook Manual Run"
    echo "4. Show Current Git Tags"
    echo "5. Show Commit History"
    echo "6. Exit"
    echo ""
    read -p "Wähle eine Option: " choice
    
    case $choice in
        1)
            clear
            echo -e "${BLUE}=== Parsing Tests ===${NC}\n"
            test_parsing "feat(auth): Login hinzugefügt"
            test_parsing "fix(bug): Crash behoben"
            test_parsing "docs: README aktualisiert"
            test_parsing "feat(api)!: API Schema geändert"
            test_parsing "refactor: Code reorganisiert"
            test_parsing "random: Kein CC Format"
            show_menu
            ;;
        2)
            clear
            echo -e "${BLUE}=== Version Calculation Tests ===${NC}\n"
            test_version_calculation "0.0.0" "feat"
            test_version_calculation "0.1.0" "fix"
            test_version_calculation "1.0.0" "feat"
            test_version_calculation "1.2.3" "BREAKING"
            show_menu
            ;;
        3)
            clear
            echo -e "${BLUE}=== Hook Manual Run ===${NC}\n"
            log_info "Running semantic-versioning.sh manually..."
            bash "$SEMANTIC_SCRIPT"
            echo ""
            show_menu
            ;;
        4)
            clear
            echo -e "${BLUE}=== Current Git Tags ===${NC}\n"
            if git tag | grep -q .; then
                git tag -l --format='%(refname:short) - %(creatordate:iso) - %(subject)'
            else
                echo "No tags found"
            fi
            echo ""
            show_menu
            ;;
        5)
            clear
            echo -e "${BLUE}=== Git Commit History ===${NC}\n"
            git log --oneline -10
            echo ""
            show_menu
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            show_menu
            ;;
    esac
}

# Check if script is run in a git repository
if [ ! -d .git ]; then
    log_error "Nicht in einem Git-Repository!"
    exit 1
fi

show_menu
