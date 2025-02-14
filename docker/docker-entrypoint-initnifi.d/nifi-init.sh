#!/usr/bin/env bash

set -e

# Path to the PostgreSQL JDBC driver
POSTGRES_JAR_PATH="/opt/nifi/nifi-current/lib/postgresql-42.2.8.jar"
SQLITE_JAR_PATH="/opt/nifi/nifi-current/lib/sqlite-jdbc-3.48.0.0.jar"
JYTHON_JAR_PATH="/opt/nifi/nifi-current/lib/jython-standalone-2.7.4.jar"

# Check if the file already exists
if [ -f "$POSTGRES_JAR_PATH" ]; then
    echo "PostgreSQL JDBC driver already exists at $POSTGRES_JAR_PATH"
else
    echo "Downloading PostgreSQL JDBC driver..."
    curl -o "$POSTGRES_JAR_PATH" https://jdbc.postgresql.org/download/postgresql-42.2.8.jar
fi

# Check if the file already exists
if [ -f "$SQLITE_JAR_PATH" ]; then
    echo "SQLite JDBC driver already exists at $SQLITE_JAR_PATH"
else
    echo "Downloading SQLite JDBC driver..."
    curl -o "$SQLITE_JAR_PATH" https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.48.0.0/sqlite-jdbc-3.48.0.0.jar
fi

# Check if the file already exists
if [ -f "$JYTHON_JAR_PATH" ]; then
    echo "SQLite Jython driver already exists at $SQLITE_JAR_PATH"
else
    echo "Downloading Jython lib..."
    curl -o "$JYTHON_JAR_PATH" https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.4/jython-standalone-2.7.4.jar
fi



# Call the original entrypoint script to start NiFi
exec /opt/nifi/scripts/start.sh