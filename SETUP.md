# Semantic Versioning Git Hook System - Übersicht

## 📋 Was wurde erstellt?

Dieses System implementiert **automatisches Semantic Versioning** mit **Conventional Commits** für Ihr Git-Repository.

### Dateien & Ordnerstruktur

```
semantic/
├── .git/
│   └── hooks/
│       └── post-commit              ← Git Hook (wird nach jedem Commit ausgeführt)
├── scripts/
│   ├── semantic-versioning.sh        ← Hauptscript (Analysiert & erstellt Tags)
│   ├── setup-hooks.sh                ← Setup-Script (einmalige Konfiguration)
│   └── test-semantic-versioning.sh   ← Test-Suite (Debugging & Demos)
├── .semantic-versioning-config.json  ← Referenz-Konfiguration
├── README_SEMANTIC_VERSIONING.md     ← Ausführliche Dokumentation
├── QUICKSTART.md                     ← Schnelleinstieg
└── SETUP.md                          ← Diese Datei
```

---

## 🚀 Schnellstart

### 1. Hooks installieren (einmalig)

**Git Bash / Terminal:**
```bash
cd c:/Users/TAACALO7/schule/Dao/M324/semantic
bash scripts/setup-hooks.sh
```

### 2. Commits mit Format erstellen

```bash
git commit -m "feat: Neue Funktion"    # → v0.1.0
git commit -m "fix: Bug behoben"       # → v0.0.1
git commit -m "feat!: Breaking Change" # → v1.0.0
```

### 3. Tags prüfen

```bash
git tag -l                              # Alle Tags anzeigen
git describe --tags                     # Aktuelle Version
```

---

## 📚 Dokumentation

| Datei | Zweck |
|-------|-------|
| **QUICKSTART.md** | 👈 Anfänger? START HIER! Schnelle Übersicht |
| **README_SEMANTIC_VERSIONING.md** | Vollständige Dokumentation & Referenz |
| **.semantic-versioning-config.json** | Technische Konfiguration & Details |

---

## 🎯 Conventional Commits Format

```
<type>(<scope>): <subject>
```

### Typen und Versionierung

| Typ | Bedeutung | Version |
|-----|-----------|---------|
| `feat:` | Neue Funktion | **MINOR** ↑ (0.1.0) |
| `fix:` | Bug-Fix | **PATCH** ↑ (0.0.1) |
| `feat!:` | Breaking Change | **MAJOR** ↑ (1.0.0) |
| `docs:` | Dokumentation | **PATCH** ↑ (0.0.1) |
| `style:`, `refactor:`, `perf:`, `test:` | Sonstiges | **PATCH** ↑ (0.0.1) |

### Beispiele

```bash
git commit -m "feat(auth): OAuth2 Support hinzugefügt"
# Version: 0.0.0 → 0.1.0 (neue Feature)

git commit -m "fix(db): Connection-Leck repariert"  
# Version: 0.1.0 → 0.1.1 (Bug-Fix)

git commit -m "feat(api)!: API-Redesign"
# Version: 0.1.1 → 1.0.0 (Breaking Change)
```

---

## 📖 Semantic Versioning Schema

```
Version: MAJOR.MINOR.PATCH
         1      .2     .3

1 (MAJOR)  = Inkompatible Änderungen
2 (MINOR)  = Neue Features (abwärtskompatibel)
3 (PATCH)  = Bug-Fixes (abwärtskompatibel)
```

**Beispiel-Progression:**
```
Initial:    v0.0.0
+ Feature:  v0.1.0  (feat:)
+ Bug-Fix:  v0.1.1  (fix:)
+ Feature:  v0.2.0  (feat:)
+ Breaking: v1.0.0  (feat!: oder BREAKING CHANGE:)
```

---

## 🛠️ Skripte Übersicht

### `semantic-versioning.sh` (Hauptscript)

**Was macht es:**
1. Liest die aktuelle Commit-Message
2. Findet den letzten Git Tag
3. Analysiert den Commit-Type (feat, fix, etc.)
4. Berechnet die neue Version (MAJOR.MINOR.PATCH)
5. Erstellt einen neuen Git Tag

**Wann wird es ausgeführt:**
- Automatisch nach jedem `git commit` (via post-commit Hook)

### `setup-hooks.sh` (Einmalige Konfiguration)

**Was macht es:**
1. Setzt Dateiberechtigungen
2. Konfiguriert Git Hook-Pfad
3. Erstellt initiales v0.0.0 Tag

**Wann wird es ausgeführt:**
```bash
bash scripts/setup-hooks.sh  # Manuell, nur EINMALIG
```

### `test-semantic-versioning.sh` (Debugging)

**Was macht es:**
- Test-Suite mit interaktivem Menü
- Parst verschiedene Commit-Formate
- Berechnet Versionen
- Zeigt aktuelle Tags

**Wann wird es ausgeführt:**
```bash
bash scripts/test-semantic-versioning.sh  # Für Tests & Debugging
```

---

## 🔧 Installation & Aktivierung

### Windows (Git Bash)

```bash
# 1. Ins Verzeichnis navigieren
cd c:/Users/TAACALO7/schule/Dao/M324/semantic

# 2. Setup ausführen
bash scripts/setup-hooks.sh

# 3. Fertig! ✓
```

### Linux / macOS

```bash
# 1. Ins Verzeichnis navigieren
cd ~/schule/Dao/M324/semantic

# 2. Setup ausführen
bash scripts/setup-hooks.sh

# 3. Fertig! ✓
```

---

## 📝 Workflow-Beispiel

### Tag 1: Start (v0.0.0)
```bash
bash scripts/setup-hooks.sh
# ✓ v0.0.0 erstellt
```

### Tag 2: Erste Feature
```bash
git commit -m "feat: Authentication System"
# Hook läuft automatisch
# ✓ v0.1.0 erstellt
git describe --tags  # v0.1.0
```

### Tag 3: Bug-Fix
```bash
git commit -m "fix: Token Validation Error"
# Hook läuft automatisch
# ✓ v0.1.1 erstellt
```

### Tag 4: Mehr Features
```bash
git commit -m "feat: Payment Integration"
# ✓ v0.2.0 erstellt

git commit -m "feat: Admin Dashboard"
# ✓ v0.3.0 erstellt
```

### Tag 5: Breaking Change → Major Version
```bash
git commit -m "feat(api)!: Complete API Redesign"
# ✓ v1.0.0 erstellt
```

---

## ⚠️ Häufige Probleme

### Problem: Hook wird nicht ausgeführt
**Lösung:**
```bash
git config core.hooksPath .git/hooks
bash scripts/setup-hooks.sh
```

### Problem: Kein neuer Tag nach Commit
**Häufige Ursachen:**
- Commit-Message folgt nicht Conventional Commits Format
- Hook hat keine Ausführungsrechte

**Test:**
```bash
bash scripts/semantic-versioning.sh  # Manuell testen
```

### Problem: Tag existiert bereits
**Lösung:**
```bash
git tag -d v1.0.0           # Lokal löschen
git commit -m "fix: Retry"  # Erneut verschieben
```

---

## 📤 Tags zum Remote pushen

```bash
# Alle Tags pushen
git push origin --tags

# Spezifisches Tag pushen
git push origin v1.0.0

# Tags in Remote anzeigen
git ls-remote --tags origin
```

---

## 🧪 Test-Modus

Für Testing & Debugging:

```bash
# Interaktive Test-Suite starten
bash scripts/test-semantic-versioning.sh

# Manuell Tag erstellen
git commit -m "feat: Test Feature"

# Tags anzeigen
git tag -l --format='%(refname:short) - %(creatordate:iso)'
```

---

## 📚 Weitere Ressourcen

- 📖 **Semantic Versioning Spezifikation:** https://semver.org/lang/de/
- 📝 **Conventional Commits Standard:** https://www.conventionalcommits.org/
- 🔧 **Git Hooks Dokumentation:** https://git-scm.com/docs/githooks

---

## ✅ Nächste Schritte

1. ✓ System ist installiert
2. ➜ **Führe aus:** `bash scripts/setup-hooks.sh`
3. ➜ **Erstelle Commit:** `git commit -m "feat: Erste Funktion"`
4. ➜ **Prüfe Tag:** `git tag -l` oder `git describe --tags`
5. ➜ **Dokumentation:** Lies `QUICKSTART.md` für Beispiele

---

## 📞 Fehlerbehandlung

Falls der Hook nicht funktioniert:

1. **Manuell testen:**
   ```bash
   bash scripts/semantic-versioning.sh
   ```

2. **Verbose Mode:**
   ```bash
   GIT_TRACE=1 git commit -m "feat: Test"
   ```

3. **Berechtigungen prüfen:**
   ```bash
   ls -la .git/hooks/
   ls -la scripts/
   ```

---

**Version:** 1.0.0  
**Status:** Produktionsbereit ✓  
**Zuletzt aktualisiert:** 2026-09-16
