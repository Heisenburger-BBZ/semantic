# Schnellstart: Semantic Versioning Setup

## Für Anfänger

### 1️⃣ Setup durchführen

**Windows (Git Bash):**
```bash
bash scripts/setup-hooks.sh
```

**Linux / macOS:**
```bash
bash scripts/setup-hooks.sh
```

### 2️⃣ Commit mit Conventional Commits Format

```bash
# Neue Funktion → Version +0.1.0
git commit -m "feat(login): Benutzer-Authentifizierung hinzugefügt"

# Bug behoben → Version +0.0.1
git commit -m "fix(ui): Button-Layout repariert"

# Breaking Change → Version +1.0.0
git commit -m "feat(api)!: Komplette API Umstrukturierung"
```

### 3️⃣ Ergebnisse prüfen

```bash
# Tags anzeigen
git tag

# Spezifischen Tag anzeigen
git describe --tags
```

---

## Häufige Szenarien

### Szenario 1: Erstes Setup

```bash
# 1. Repository initialisieren
git init
cd /pfad/zum/repo

# 2. Hooks installieren
bash scripts/setup-hooks.sh

# 3. Erste Datei hinzufügen
echo "Projekt Start" > README.md
git add README.md
git commit -m "feat: Initial commit"
# → Automatisch erstellt Tag v0.1.0
```

### Szenario 2: Mehrere Commits in Entwicklung

```bash
# Mehrere kleine Fixes
git commit -m "fix(auth): Token-Validierung"        # v0.0.1 → v0.0.2
git commit -m "fix(db): Verbindungsleck"            # v0.0.2 → v0.0.3

# Neue Features
git commit -m "feat(api): REST Endpoints"           # v0.0.3 → v0.1.0
git commit -m "feat(cache): Redis Integration"      # v0.1.0 → v0.2.0

# Breaking Change
git commit -m "feat(core)!: Neuer Core"             # v0.2.0 → v1.0.0
```

### Szenario 3: Kein Auto-Tagging für bestimmte Commits

```bash
# Dokumentation-Commits erhalten auch Tags (patch)
git commit -m "docs: API Dokumentation"             # +0.0.1

# Diese Commits erhalten KEINE Tags
git commit -m "Schnelle Notiz"                      # ⚠️ Kein Tag

# Lösung: Conventional Commits Format verwenden
git commit -m "docs: Update README"                 # +0.0.1
```

---

## Befehle Schnellereferenz

| Aktion | Befehl |
|--------|--------|
| Setup ausführen | `bash scripts/setup-hooks.sh` |
| Manuell Hook testen | `bash scripts/semantic-versioning.sh` |
| Test-Suite öffnen | `bash scripts/test-semantic-versioning.sh` |
| Tags anzeigen | `git tag -l` |
| Spezifische Version sehen | `git describe --tags` |
| Tags zum Remote pushen | `git push origin --tags` |
| Lokal erstellte Tags löschen | `git tag -d v1.0.0` |
| Remote Tag löschen | `git push origin :refs/tags/v1.0.0` |

---

## Conventional Commits - Kurzform

```
<type>(<scope>): <subject>
```

**Types:**
- `feat` → Neue Funktion (MINOR)
- `fix` → Bug-Fix (PATCH)
- `docs` → Dokumentation (PATCH)
- `style` → Code-Stil (PATCH)
- `refactor` → Umstrukturierung (PATCH)
- `perf` → Performance (PATCH)
- `test` → Tests (PATCH)

**Breaking Changes:**
- Mit `!` am Ende des Types: `feat!:` oder `fix!:`
- Oder im Body: `BREAKING CHANGE: ...`

**Beispiele:**
```bash
git commit -m "feat(auth): OAuth2 Support"
git commit -m "fix(api): Error Handling verbessert"
git commit -m "docs: Fehler im Changelog"
git commit -m "refactor(core)!: Neue Architektur"
git commit -m "perf(db): Query Optimization"
```

---

## Fehlerbehandlung

### Hook wird nicht ausgeführt?

```bash
# 1. Berechtigungen prüfen
ls -la .git/hooks/post-commit

# 2. Script direkt testen
bash scripts/semantic-versioning.sh

# 3. Git hooks konfigurieren
git config core.hooksPath .git/hooks

# 4. Verbose Mode (zeigt was passiert)
GIT_TRACE=1 git commit -m "feat: Test"
```

### Tag bereits vorhanden?

```bash
# Alten Tag löschen (lokal)
git tag -d v1.0.0

# Alten Tag löschen (remote)
git push origin :refs/tags/v1.0.0

# Neuerstellen
git commit -m "feat: Retry"
```

---

## Nächste Schritte

1. **Tags zum Remote pushen:**
   ```bash
   git push origin --tags
   ```

2. **Tags in CI/CD verwenden:**
   ```bash
   VERSION=$(git describe --tags)
   echo "Building version: $VERSION"
   ```

3. **Release-Automation:**
   - Nutze die Tags für automatische Releases
   - Erstelle GitHub/GitLab Releases basierend auf Tags
   - Deploye spezifische Versionen

---

## Weitere Hilfe

- 📖 **Semantic Versioning:** https://semver.org/lang/de/
- 📝 **Conventional Commits:** https://www.conventionalcommits.org/
- 🔧 **Git Hooks:** https://git-scm.com/docs/githooks

Fragen? Siehe `README_SEMANTIC_VERSIONING.md` für ausführliche Dokumentation!
