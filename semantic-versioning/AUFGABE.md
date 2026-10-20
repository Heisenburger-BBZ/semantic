Aufgaben
Teil 1: Scripts im package.json vorbereiten
Erstellt oder ergänzt die Scripts im package.json, sodass ihr alle drei Schritte einzeln starten könnt:

Unit Tests: npm run test:unit

E2E Tests: npm run test:e2e

Linter: npm run lint

Alle drei Scripts sollen lokal und in der Pipeline verwendet werden können. Nutzt in den GitHub Workflows diese Scripts, um die jeweiligen Schritte auszuführen.

Achtet darauf, dass die Tests einmalig ausgeführt werden und danach beendet sind. Verwendet deshalb keinen Watch-Modus. Der Linter soll Fehler melden und mit einem Fehlerstatus beenden, ohne diese automatisch zu korrigieren.

Teil 2: Tests und Linter in der Merge Request Pipeline
Erweitert eure GitHub Workflows, sodass bei einem Pull Request auf den main Branch automatisch die Unit Tests, E2E Tests und der Linter ausgeführt werden.

Die drei Schritte sollen beim Erstellen eines Pull Requests und bei jedem weiteren Push auf dessen Branch erneut laufen.

Achtet darauf, dass:

alle drei Schritte ohne manuellen Eingriff ausgeführt werden.

fehlgeschlagene Tests oder Lint-Fehler die Pipeline fehlschlagen lassen.

in der Pull Request Pipeline keine Tags erstellt werden.

Teil 3: Tests und Linter in der main Pipeline
Nach dem Merge eines Pull Requests sollen die Unit Tests, E2E Tests und der Linter auf dem main Branch erneut ausgeführt werden.

Passt eure bestehende Pipeline so an, dass folgende Reihenfolge eingehalten wird:

Unit Tests, E2E Tests und Linter ausführen. Diese Schritte dürfen parallel laufen.

Den neuen Tag erst erstellen, wenn alle drei Schritte erfolgreich waren.

Nutzt für das Taggen weiterhin euer Script aus der letzten Aufgabe.

Teil 4: Pipeline überprüfen
Überprüft zuerst, ob ihr alle drei Schritte lokal über die Scripts im package.json starten könnt.

Erstellt anschliessend einen neuen Branch und baut absichtlich einen Fehler ein, welcher einen Test fehlschlagen lässt. Erstellt einen Pull Request und überprüft, ob die Pipeline den Fehler erkennt.

Testet ebenfalls, ob ein Lint-Fehler die Pipeline fehlschlagen lässt. Behebt danach die Fehler und pusht die Änderungen erneut.

Merged den Pull Request, sobald alle drei Schritte grün sind, und kontrolliert, ob auf dem main Branch die Unit Tests, E2E Tests und der Linter erneut ausgeführt werden und anschliessend ein neuer Tag erstellt wird.