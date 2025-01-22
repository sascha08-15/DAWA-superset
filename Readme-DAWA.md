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
 * Connection String: postgresql://examples:XXXXXXXXXX@db:5432
 * Username: examples
 * Passwort: XXXXXXXXXX
 * Port: 5432
