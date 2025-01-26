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

 ## Apache NIFI
 * Navigiere zur URL https://localhost:18443/
 * Einloggen mit u.s. Informationen
 * Username: admin
 * Passwort: adminadminadmin
