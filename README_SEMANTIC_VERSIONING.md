# Semantic Versioning Git Hook Setup

## Übersicht

Dieses Projekt nutzt automatische Git Hooks für **Semantic Versioning** mit **Conventional Commits**.

Nach jedem Commit wird automatisch:
1. Die Commit-Message analysiert
2. Die Versionsnummer angepasst
3. Ein neuer Git-Tag erstellt

## Setup

### 1. Hooks ausführbar machen

**Linux/macOS:**
```bash
chmod +x .git/hooks/post-commit
chmod +x scripts/semantic-versioning.sh
```

**Windows (Git Bash):**
```bash
git update-index --chmod=+x .git/hooks/post-commit
git update-index --chmod=+x scripts/semantic-versioning.sh
```

Alternativ in PowerShell:
```powershell
icacls ".git\hooks\post-commit" /grant:r "$env:USERNAME`:F"
icacls "scripts\semantic-versioning.sh" /grant:r "$env:USERNAME`:F"
```

### 2. Automatisches Verzeichnis-Setup (optional)

Zum automatischen Installieren der Hooks verwenden Sie:
```bash
git config core.hooksPath .git/hooks
```

## Conventional Commits Format

Die Commit-Messages müssen folgendes Format einhalten:

```
<type>(<scope>): <subject>
<blank line>
<body>
<blank line>
<footer>
```

### Typen und Versionierung

| Typ       | Beschreibung                | Version |
|-----------|----------------------------|---------|
| `feat:`   | Neue Funktion              | MINOR ↑ |
| `fix:`    | Bug-Fix                    | PATCH ↑ |
| `docs:`   | Dokumentation              | PATCH ↑ |
| `style:`  | Code-Stil (kein Verhalten) | PATCH ↑ |
| `refactor:` | Code umstrukturieren      | PATCH ↑ |
| `perf:`   | Performance                | PATCH ↑ |
| `test:`   | Tests                      | PATCH ↑ |

### Breaking Changes

Für Breaking Changes verwenden Sie entweder:

**Variante 1:** Exclamation Mark
```
feat(api)!: neue API Version
```

**Variante 2:** Footer
```
feat(api): neue API Version

BREAKING CHANGE: alte API entfernt
```

→ Erhöht **MAJOR** Version um 1

## Beispiele

### Beispiel 1: Bug-Fix (Patch Version)
```bash
git commit -m "fix(auth): Login-Fehler behoben"
# Version: 1.0.0 → 1.0.1
# Tag: v1.0.1
```

### Beispiel 2: Neue Funktion (Minor Version)
```bash
git commit -m "feat(api): neuer Endpunkt für Benutzer"
# Version: 1.0.1 → 1.1.0
# Tag: v1.1.0
```

### Beispiel 3: Breaking Change (Major Version)
```bash
git commit -m "feat(api)!: kompletter API Redesign"
# Version: 1.1.0 → 2.0.0
# Tag: v2.0.0
```

## Versionierungsschema (Semantic Versioning)

```
MAJOR.MINOR.PATCH
1    .2     .3

- MAJOR: Inkompatible API-Änderungen
- MINOR: Neue Features (abwärtskompatibel)
- PATCH: Bug-Fixes (abwärtskompatibel)
```

**Initial-Version:** `0.0.0`

## Troubleshooting

### Hook wird nicht ausgeführt

1. Prüfen Sie die Dateirechte:
   ```bash
   ls -la .git/hooks/post-commit
   ```

2. Hook manuell testen:
   ```bash
   bash scripts/semantic-versioning.sh
   ```

3. Git-Hooks aktivieren:
   ```bash
   git config core.hooksPath .git/hooks
   ```

### Tag-Erstellung fehlgeschlagen

- Prüfen Sie, ob der Tag bereits existiert
- Löschen Sie alte Tags bei Bedarf: `git tag -d <tagname>`
- Stellen Sie sicher, dass keine Merge-Konflikte vorhanden sind

### Keine Tags werden erstellt

- Überprüfen Sie, dass die Commit-Message das Conventional Commits Format erfüllt
- Sehen Sie sich das Skript-Output an für Fehlermeldungen

## Manuelle Tag-Erstellung

Falls der Hook deaktiviert ist, können Sie Tags auch manuell erstellen:

```bash
# Manuell Tag erstellen
git tag -a v1.0.0 -m "Release 1.0.0"

# Tags anzeigen
git tag -l

# Tags zum Remote pushen
git push origin v1.0.0
git push origin --tags  # Alle Tags
```

## Git-Konfiguration

Empfohlene globale Git-Konfiguration für Conventional Commits:

```bash
# Autor setzen
git config user.name "Ihr Name"
git config user.email "ihre.email@example.com"

# Hook-Pfad setzen
git config core.hooksPath .git/hooks
```

## Dateien

- `.git/hooks/post-commit` - Hook-Skript (wird nach jedem Commit ausgeführt)
- `scripts/semantic-versioning.sh` - Hauptlogik für Versionierung und Tagging

## Weitere Ressourcen

- [Semantic Versioning](https://semver.org/lang/de/)
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [Git Hooks Dokumentation](https://git-scm.com/docs/githooks)
