# Business Intelligence mit Apache Superset
In dieser Übung werden Sie mit Apache Superset vertraut. Dazu verwenden Sie ein Enterprise-Grade Tool, das in der Lage ist Datenquellen visuell darzustellen. Superset ist prinzipiell als No-Code oder Low-Code Umgebung ausgelegt, erfordert aber im Detail ein wenig technisches Know-how. Machen Sie sich zunächst mit der Superset Dokumentation vertraut (https://superset.apache.org/docs/intro). 
## Eingesetzte Tools
* Infrastruktur
    * SSH
    * Git
    * Docker
* ETL
    * Apache Superset
* Datenbank Tool
    * DBeaver
* Datenbanken
    * PostgreSQL

## HSLU Maschine oder lokales Docker Image
Sie sind frei in der Wahl der Infrastruktur
### 1. HSLU Server
* Die Services sollten bereits zugänglich sein.
* Beachten Sie, dass der Hostname immer spezifisch für Ihre Gruppe angepasst werden muss in den URLs.

### 2. Lokale Services via Docker Compose File
* Es steht ein Github Workspace bereit, den Sie über `git clone https://github.com/sascha08-15/DAWA-superset.git` auscheckend können.
* Stellen Sie die korrekte Installation von Docker Compose v2 sicher.
* Sodann können Sie die Services mit dem Befehl `docker compose up` starten. Beachten Sie, dass beim initialen Laden der Vorgang länger dauert.
    1) Docker Images werden heruntergeladen.
    2) Datenbanken werden erstellt.
    2) Beispieldaten werden in die PostgreSQL Datenbank geladen.

# Superset Login
* Öffnen sie die Superset URL in ihrem Browser ``https://localhost:18088``, wobei Sie `localhost` mit dem Ihnen zugeteilten Hostnamen ersetzt müssen.
* Akzeptieren Sie etwaig unsicheren Zugriff (wegen des nicht offiziellen HTTPs SSL-Zertifikats).
* *Optional:* Bookmarken Sie sich die URL um später einfacher Zugriff auf Superset zu haben.


# Superset verstehen
* Erkunden Sie die existierenden Daten mit Hilfe der Boardmittel von Superset.
    * Dashboards
    * Charts
    * Datasets

# Datenmodelle anlegen
* Installieren Sie DBeaver Community (https://dbeaver.io/download/).
* Öffnen Sie DBeaver.
* Richten Sie die Datenquelle für PostgreSQL ein (vgl. https://dbeaver.com/docs/dbeaver/).
* Die Zugangsdaten finden Sie im [./Readme-DAWA.md](Readme-DAWA.md).
* Stellen Sie sicher, dass in der Datenbank `dawa` vorhanden ist; wobei noch keine Tabellen vorhanden sind.

# Daten in PostgreSQL laden
* Über DBeaver führen Sie folgendes Skript aus:
    ```sql
    CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    product VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
    );
    INSERT INTO sales (date, product, quantity, price) VALUES
    ('2025-01-01', 'Product A', 10, 9.99),
    ('2025-01-02', 'Product B', 5, 19.99),
    ('2025-01-03', 'Product A', 7, 9.99),
    ('2025-01-04', 'Product C', 3, 29.99),
    ('2025-01-05', 'Product B', 8, 19.99),
    ('2025-01-06', 'Product C', 2, 29.99),
    ('2025-01-07', 'Product A', 15, 9.99);
    ```
* Konfigurieren Sie in Superset Ihre PostgreSQL Datenbank und stellen Sie sicher, dass der Zugang zur Datenbank `dawa` funktioniert. 
    * Sie können wahlweise die Datenquelle manuell Konfigurieren oder den SQLAlchemy-Connection-String verwenden.
* Konfigurieren Sie in Superset ein Query, um die Daten in der Tabelle `sales` abzurufen.
    * Gehen Sie dazu in das SQL Lab.
    * Speichern Sie das Query.
* Konfigurieren Sie eine Visualisierung in Superset, dass die Daten darstellt.
    * Als X-Achse verwenden Sie `product`.
    * Als Metrik berechnen Sie den Preis aus `quantity * price`.

# Dimension Table erstellen
* Verwenden Sie DBeaver für nachfolgende Datenbankanpassungen.
* Erstellen Sie für die Dimension `date` eine **Dimension Table**. Insbesondere ist der Wochentag relevant, da Ihr Auftraggeber meint, dass Montags immer viel mehr bestellt wird als an allen andern Wochentagen.
* Führen Sie folgendes SQL Statement in DBeaver aus
    ```sql
    INSERT INTO sales (date, product, quantity, price) VALUES
    ('2024-01-01', 'Product A', 10, 9.99),
    ('2024-01-02', 'Product B', 5, 19.99),
    ('2024-01-03', 'Product A', 7, 9.99),
    ('2024-01-04', 'Product C', 3, 29.99),
    ('2024-01-05', 'Product B', 8, 19.99),
    ('2024-01-06', 'Product C', 2, 29.99),
    ('2024-01-07', 'Product A', 15, 9.99);
    ```
* Aktualisieren Sie auch Ihre ***Dimension Table***.
* Nun legen Sie in Superset ein weiteres Query an, das die Wochentage über das Star-Schema mit im Query-Ergebnis darstellt.
* Visualisieren Sie das Ergebnis in Superset.

# Kontollfragen

## Mögliche Fehlerquellen

* Die Datenbank `dawa` ist nicht zugänglich (über DBeaver oder Superset).
    * Vergleichen Sie den Connection String mit den Credentials in Readme-DAWA.md.
    * Stellen Sie die Korretke eingabe des Nutzernames und Passwort sicher.
