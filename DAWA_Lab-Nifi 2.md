# ETL mit Apache Nifi 2.2
In dieser Übung werden Sie mit ETL (Extract, Transform, Load) vertraut. Dazu verwenden Sie ein Enterprise-Grade Tool, das verschiedenste Datenquellen anbinden kann; sowohl als Quelle als auch als Ziel. Nifi ist prinzipiell als No-Code oder Low-Code Umgebung ausgelegt, erfordert aber technisches Know-how. Machen Sie sich zunächst mit der Nifi Dokumentation vertraut (https://nifi.apache.org/nifi-docs/getting-started.html). 
## Eingesetzte Tools
* Infrastruktur
    * SSH
    * Git
    * Docker
* ETL
    * Apache Nifi
* Datenbank Tool
    * DBeaver
* Datenbanken
    * SQLite
    * PostgreSQL
* Cache
    * Redis

# Datenmodelle anlegen
* Das Datenmodell wird durch den Flow automatisch angelegt
    * Prüfen Sie die Rolle der Processors `GenerateFlowFile`, `PutSQL`, sowie `Notify` und `Wait`.

# Nifi Login
* Öffnen sie die Nifi URL in ihrem Browser ``https://localhost:18443``, wobei Sie `localhost` mit dem Ihnen zugeteilten Hostnamen ersetzt müssen.
* Akzeptieren Sie etwaig unsicheren Zugriff (wegen des nicht offiziellen HTTPs SSL-Zertifikats).


# Nifi Flow importieren
* Ziehen Sie eine Process Group auf das Nifi Canvas.
* Klicken Sie auf das Icon *browse* im Feld `Name`.
    * Navigieren Sie zu dem Verzeichnis ``nifi-staging/Flowfiles``.
    * Öffnen Sie ``LoadCSV.json``.
    * Bestätigen Sie den Import im Dialog.
* Sie können nun in die importierte Process Group hinein navigieren.

# Nifi Controller Services aktivieren
* Rechtsklick auf das Canvas erlaubt Ihnen die konfigurierten **Controller Services** einzusehen.
* Aktivieren Sie alle Services, z.B. `AvroReader` oder `DBCPConnectionPool`.
* Navigieren Sie auch in die Untergruppen `CSV Import` und `WriteDimensionTable` und aktivieren die Services.
* Sie können auch mit Klick auf `Enable All Controller Servies` alle Services auf einmal aktivieren.

# Nifi Flow ausführen
* Drücken Sie den `Start` Button ▶️ auf dem Canvas.
* Beobachten Sie, wie Daten fliessen.
* Nehmen Sie sich zeit genau nachzuvollziehen, was vor sich geht.
* Kopieren Sie die Datei `nifi-stating/archive/countries-regions.csv` nach `nifi-stating/countries-regions.csv`.
* Beachten Sie, dass Nifi diese Datei *konsumiert*. Finden Sie in dem Processor genau die Stelle, um dieses Verhalten zu konfigurieren.


# Kontollfragen

## Mögliche Fehlerquellen

* Der Flow wird nicht gestartet
    * Stellen Sie sicher, dass alle Services mit *enable* auch aktiv sind.

* Es ist möglich, dass Sie die Fehlermeldung `org.postgresql.util.PSQLException: FATAL: sorry, too many clients already` erhalten.
    * In diesem Fall stellen Sie sicher, dass im Service `DBCPConnectionPool(PostgreSQL)` das Passwort korrekt hinterlegt ist.
    * Den `DBCPConnectionPool(PostgreSQL)` finden Sie im Processor `PutDatabaseRecord`.
    * Klick auf `Verification` bestätigt bei korrekter Konfiguration die erfolgreiche Verbindung zur Datenbank.