# DAWA
Dies ist die Anleitung für die Lehrveranstaltung DAWA.
Die wesentlichen Schritte werden hier beschrieben. Da die verwendete Software Änderungen unterliegt, gelten zusätzlich als Hilfestellung
* Aktuelle Dokumentation von Docker: https://docs.docker.com/get-started/introduction/
* Aktuelle Dokumentation von Git: https://git-scm.com/doc
* Aktuelle Dokumentation von Superset: https://superset.apache.org/docs/quickstart/


# Voraussetzungen
* Installieren Sie Docker
* Installieren Sie Git
* Starten Sie Docker (Deamon oder Docker Desktop, je nachdem Ob Windows, Linux oder MacOS genutzt wird)

# Architekturbeschreibung (Quellen - ETL Pipeline - DWH - BI)
Die Architekturbeschreibung erfolgt Bottom-up:
* Als Datenquellen kommt ein CSV-File und eine SQLite Datenbank (Dokumentation https://www.sqlite.org/docs.html) zum Einsatz.
* Wir verwenden für den ETL Prozess Apache Nifi (Dokumentation https://nifi.apache.org/components/).
* Als Datawarehouse kommt PostgreSQL (Dokumentation https://www.postgresql.org/docs/) zum Einsatz; dort kann sowohl ein Star-Schema, als auch ein Snowflake-Schema realisiert werden.
* Zum Analysieren und Visualisieren kommt Apache Superset zum Einsatz (Dokumentation https://superset.apache.org/docs/intro).

Die Komponenten sind prinzipiell alle so in dem Docker-Compose-File konfiguriert, so dass ein Zusammenspiel reibungslos funktioniert.

Bei Fragen, schauen Sie zuerst in diese Anleitung, danach in die jeweilige Dokumentation. Versuchen Sie das Problem zu lokalisieren und analysieren Sie selbst. Verwenden Sie AI (Copilot, ChatGPT, Gemini, etc.) - die verwendeten Komponenten sind den AI Tools bestens bekannt.
Sollte das Problem und die Frage dennoch bestehen bleiben, liefern Sie mit:
* 1) Was ist das Problem? 
* 2) Was sagt die Dokumentation?
* 3) Was sagt GenAI tools?
* 4) Was sind versuchte Lösungsansätze?
* 5) Wie sieht ein möglicher Workaround aus?
  
# Apache Superset über Docker Compose starten
* Starten Sie eine console/terminal und navigieren sie zum gewünschten Verzeichnis (z.B. ```mkdir DATA``` und ```cd ~/DAWA```)
* Clonen Sie das Repository mit ```git clone https://github.com/apache/superset.git```
* Navigieren Sie in das neu erstelle Verzeichnis ```cd superset```
* Mit ```git checkout tags/4.1.1``` verwenden Sie genau eine stabile Release-Version
* Starten Sie Apache Superset mit ```docker compose -f docker-compose-image-tag.yml up```

# Verfügbare Services
 ## Die Apache Superset Umgebung 
 * Navigiere zur URL http://localhost:8088
 * Einloggen mit username: admin und password: admin
 ## Eine Postgres Beispiel Datenbank
 * Connection String: ```postgresql://examples:examples@db:5432/examples```
 * Username: examples
 * Passwort: examples
 * Port: 5432
 ## Eine Postgres Datenbank für ihr DAWA Projekt
 * Connection String: ```postgresql://dawauser:dawapass@db:5432/dawa```
 * Username: dawauser
 * Passwort: dawapass
 * Port: 5432

# Datenbank in Nifi einrichten
 ## Füge Sie ein Contoller Service hinzu
 * DB Connection URL: ```jdbc:postgresql://db:5432/dawa```
 * Database Driver Class Name: ```org.postgresql.Driver```
 * Database User & Password: (siehe oben, Verfügbare Services)
 * Database Driver Location(s): ```/opt/nifi/nifi-current/lib/postgresql-42.2.8.jar```
 * Klicken Sie auf "Verification"
 ## Prüfen Sie die Verification
 Sie sollten folgende Bestätigungen erhalten:
 * Perform Validation: Component Validation passed
 * Configure Data Source: Successfully configured data source
 * Establish Connection: Successfully established Database Connection
## Benennen Sie den Controller Service sinnvoll
 * Unter Settings können Sie einen Namen für den Controller Service vergeben
 * Es handelt sich um die Postgres Datenbank - vergeben Sie einen sinnvollen, sprechenden Namen für diesen Datenverbindungspool

 ## Interagieren Sie mit der Postgres Datenbank
 * Lesen Sie ```https://nifi.apache.org/docs/nifi-docs/html/getting-started.html#i-started-nifi-now-what```
 
## SQLite Datenbank in Nifi anbinden
* **Copy** SQLite DB to staging directory in the docker directory (nifi-staging).
* Add a processor to your flow and use the ```DBCPConnectionPool``` as Database Connection Pool Service - create a new service and "Go to Service" to configure it.
* Driver path: ```/opt/nifi/nifi-current/lib/sqlite-jdbc-3.48.0.0.jar```
* Driver class: ```org.sqlite.JDBC```
* Connection string: ```jdbc:sqlite:/opt/nifi/nifi-current/data/dawa.sqlite```
* SQL Select Query: ```select * from Person``` to query all columns from the Table Person.
* **Verify** the controller service
* **Enable** the controller service
* Die Datenquelle ist nun über den Service angebunden


## Daten in PostgresDB schreiben
* Erstellen Sie einen Processor ```PutDatabaseRecord```
* Nutzen Sie ```AvroReader``` als Record Reader
* Hintergrund: der Processor ```ExecuteSQL
* Erstellen Sie einen neuen Controller Service für den Record Reader
* Gehen Sie zum Service und klicken Sie auf ```enable```
* Als Database Type wählen Sie ```PostgreSQL``` aus.
* Add a processor to your flow and use the ```DBCPConnectionPool``` as Database Connection Pool Service - create a new service and "Go to Service" to configure it. (siehe oben)
* Geben Sie den  ```Table Name ``` an, z.B. vornamen
* Als  ```Statement Type ``` verwenden Sie  ```INSERT```
* Verifizieren Sie den Processor
* Erstellen Sie zunächste eine Zieltabelle mit dem DBeaver in der Postgre Datenbank ```dawa```
* Stellen Sie sicher, dass der oben gewählte Tabllenname übereinstimmt (hier: vorname)
* In DBeaver können Sie die Tabelle über die UI oder auch im SQL editor erstellen, z.B.:
```CREATE TABLE public.vorname (
	name text NULL,
	bestellungen int NULL,
	id varchar NOT NULL,
	CONSTRAINT vorname_pk PRIMARY KEY (id)
);```

* Unter Relationships aktivieren Sie ```terminate``` bei failure, retry und success.

## Datenbanken einsehen
* Laden sie sich den DBeaver Community Edition herunter und installieren sie diesen
* URL: https://dbeaver.io/download/
* Richten Sie sowohl die Datenquelle für Postgres ein als auch für die SQLite Datenbank
