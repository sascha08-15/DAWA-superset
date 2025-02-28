#!/usr/bin/env bash

set -e

# Paths to JDBC drivers
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
    echo "SQLite Jython driver already exists at $JYTHON_JAR_PATH"
else
    echo "Downloading Jython lib..."
    curl -o "$JYTHON_JAR_PATH" https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.4/jython-standalone-2.7.4.jar
fi

DAWA_DB_PATH="/opt/nifi/nifi-current/data/dawa.sqlite"

# Check if the file already exists
if [ -f "$DAWA_DB_PATH" ]; then
    echo "SQLite DB already exists at $DAWA_DB_PATH"
else
    echo "Downloading DAWA SQLite DB..."
    curl -o "$DAWA_DB_PATH" https://drive.switch.ch/index.php/s/iDQFw6FzI8d5S5w/download &
fi

scripts_dir='/opt/nifi/scripts'

[ -f "${scripts_dir}/common.sh" ] && . "${scripts_dir}/common.sh"

echo "Nifi about to start"

cat /opt/nifi/nifi-current/conf/nifi.properties

sleep 30

# Continuously provide logs so that 'docker logs' can produce them
"${NIFI_HOME}/bin/nifi.sh" run &
nifi_pid="$!"
tail -F --pid=${nifi_pid} "${NIFI_HOME}/logs/nifi-app.log" &

trap 'echo Received trapped signal, beginning shutdown...;./bin/nifi.sh stop;exit 0;' TERM HUP INT;
trap ":" EXIT

echo NiFi running with PID ${nifi_pid}.
wait ${nifi_pid}


