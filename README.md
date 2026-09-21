# Semantic Version Tags

Der `post-commit`-Hook erstellt automatisch annotierte Git-Tags nach Semantic Versioning und Conventional Commits.

## Einrichten

Einmalig im Repository ausführen:

```bash
git config core.hooksPath .githooks
chmod +x .githooks/post-commit scripts/semantic-version-tag.sh
```

Unter Windows funktioniert der Hook über Git Bash; `chmod` ist dort normalerweise nicht nötig.

## Regeln

- `feat: ...` -> MINOR, z. B. `v1.2.0` -> `v1.3.0`
- `fix: ...` oder `perf: ...` -> PATCH, z. B. `v1.2.0` -> `v1.2.1`
- `feat!: ...`, `fix!: ...` oder ein Footer `BREAKING CHANGE: ...` -> MAJOR
- Andere Conventional-Commit-Typen (`docs`, `chore`, `refactor`, `test`, `ci`, ...) erstellen keinen Tag.
- Ohne vorhandenen gültigen Tag startet die Version bei `v0.0.0`.
- Nicht-Conventional-Commits werden ignoriert.

Vor dem ersten echten Tag kann die Berechnung getestet werden:

```bash
DRY_RUN=1 scripts/semantic-version-tag.sh
```

## GitHub Actions

Die Workflows bilden die Kette `Unit Tests -> Build -> Semantic Version Tag`:

- `.github/workflows/unit-tests.yml` installiert die npm-Abhängigkeiten und führt `npm test` aus.
- `.github/workflows/build.yml` startet nur nach einem erfolgreichen Unit-Test-Workflow und führt `npm run build` aus.
- `.github/workflows/semantic-version.yml` startet nur nach einem erfolgreichen Build-Workflow, verwendet dasselbe Tagging-Script und pusht den neuen Tag mit `GITHUB_TOKEN`.

Alle Workflows verwenden die getestete Commit-Version. Dadurch werden Tags nur für Commits erzeugt, deren Tests und Build erfolgreich waren.

Damit das funktioniert, benötigt der Workflow die Berechtigung `Contents: Read and write`. Diese ist im Workflow bereits über `permissions: contents: write` gesetzt.
