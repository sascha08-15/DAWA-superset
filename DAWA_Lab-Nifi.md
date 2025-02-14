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

# Datenmodelle anlegen
* Installieren Sie DBeaver Community (https://dbeaver.io/download/).
* Öffnen Sie DBeaver.
* Richten Sie die Datenquelle für PostgreSQL ein (vgl. https://dbeaver.com/docs/dbeaver/)
* Führen Sie das nachstehende Script aus.
    ```sql
    CREATE TABLE document_fact (
        id serial4 NOT NULL,
        "name" text NULL,
        notes text NULL,
        validity_date date NULL
    );


    CREATE TABLE date_dimension (
        "date" date NOT NULL,
        day_of_week varchar NULL,
        quarter varchar NULL,
        month varchar NULL,
        year varchar NULL,
        CONSTRAINT date_dimension_pk PRIMARY KEY (date)
    );
    ```
* Stellen Sie sicher, dass in der Datenbank DAWA die beiden Tabellen `document_fact` und `date_dimension` angelegt wurden.

# Nifi Login
* Öffnen sie die Nifi URL in ihrem Browser ``https://localhost:18443``, wobei Sie `localhost` mit dem Ihnen zugeteilten Hostnamen ersetzt müssen.
* Akzeptieren Sie etwaig unsicheren Zugriff (wegen des nicht offiziellen HTTPs SSL-Zertifikats).

# Nifi Flow importieren
* Ziehen Sie eine Process Group auf das Nifi Canvas.
* Klicken Sie auf das Icon *browse* im Feld `Name`.
    * Navigieren Sie zu dem Verzeichnis ``nifi-staging/Flowfiles``.
    * Öffnen Sie ``DocumentFact_and_DateDimension.json``.
    * Bestätigen Sie den Import im Dialog.
* Sie können nun in die importierte Process Group hinein navigieren.

# Nifi Controller Services aktivieren
* Rechtsklick auf das Canvas erlaubt Ihnen die konfigurierten **Controller Services** einzusehen.
* Aktivieren Sie alle Services, z.B. `AvroReader` oder `DBCPConnectionPool`.
* Stellen die korrekte Konfiguration der Zugangsdaten in den Services für Ihre Umgebung sicher.

# Nifi Flow ausführen
* Drücken Sie den `Start` Button ▶️ auf dem Canvas.
* Beobachten Sie, wie Daten fliessen.
* Nehmen Sie sich zeit genau nachzuvollziehen, was vor sich geht.

# Nifi Logs
* Sehen Sie sich die Datei `nifi-log/nifi-app.log` an.
* Machen Sie sich mit dem **Bulletin Board** in Nifi vertraut.

# Kontollfragen
### Datenmodellierung
* Was würde passieren, wenn Sie das SQL-Skript nicht zuerst in DBeaver ausführen?
* Welche Indexe würden Sie noch verwenden und warum?
### Nifi
* Welche **Processors** sind im Einsatz?
* Was ist die Datenquelle?
    * Wie wird auf die Datenquelle zugegriffen?
    * Wohin werden die Daten geschrieben?
* Wie wird auf das Ziel zugegriffen?
* Wie wird auf die Ziel-Tabelle geschrieben?
* Werden Daten verändert (transformiert)?
    * Wie werden Daten verändert?
    * Wohin werden die Daten geleitet?
* Was geschieht beim Aktivieren der Services?
* Was ist die Rolle der Queues?
* Woher kann der Flow wissen, welche Daten zu importieren sind?
* Wieso werden nicht immer alle Daten neu importiert?
* Wie viele Datensätze auf einmal werden importiert?
* Wie häufig läuft der Datenimport?
* Was passiert wenn in der Tabelle `document` in er Quelle ein Datensatz hinzu kommt?
    * Warum ist das so?
    * Wann und wie häufig passiert das?

## Mögliche Fehlerquellen

* Der Flow wird nicht gestartet
    * Stellen Sie sicher, dass alle Services mit *enable* auch aktiv sind.

* Es ist möglich, dass Sie die Fehlermeldung `org.postgresql.util.PSQLException: FATAL: sorry, too many clients already` erhalten.
    * In diesem Fall stellen Sie sicher, dass im Service `DBCPConnectionPool(PostgreSQL)` das Passwort korrekt hinterlegt ist.
    * Den `DBCPConnectionPool(PostgreSQL)` finden Sie im Processor `PutDatabaseRecord`.

* Sie möchten nochmal ganz von vorne anfangen?
    * Zunächst stoppen Sie die Ausführung des Flows (Button ⏹️); damit wird verhindert, dass weitere Daten in die Datenbank geschrieben werden.
    * Dann löschen Sie die Daten in der Zieldatenbank über DBeaver; dabei bleibt das Schema erhalten.
        ```sql
        delete from date_dimension;
        delete from document_fact;
        ```
    * Sodann setzen Sie den *state* des `QueryDatabaseTableRecord` Processors zurück.
    * Führen Sie nun den Flow erneut aus, so beginnt der Processor "von vorne".