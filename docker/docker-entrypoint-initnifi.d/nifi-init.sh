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
    echo "Checking if SQLite DB is complete..."
    
    # Get remote file size
    REMOTE_SIZE=$(curl -sI https://drive.switch.ch/index.php/s/iDQFw6FzI8d5S5w/download | grep -i Content-Length | awk '{print $2}' | tr -d '\r')

    # Get local file size
    LOCAL_SIZE=$(stat -c %s "$DAWA_DB_PATH" 2>/dev/null)

    if [ "$LOCAL_SIZE" -eq "$REMOTE_SIZE" ]; then
        echo "SQLite DB is already fully downloaded at $DAWA_DB_PATH"
    else
        echo "Incomplete file detected. Resuming download..."
        curl -C - -o "$DAWA_DB_PATH" https://drive.switch.ch/index.php/s/iDQFw6FzI8d5S5w/download &
    fi
else
    echo "Downloading DAWA SQLite DB..."
    curl -C - -o "$DAWA_DB_PATH" https://drive.switch.ch/index.php/s/iDQFw6FzI8d5S5w/download &
fi

scripts_dir='/opt/nifi/scripts'

[ -f "${scripts_dir}/common.sh" ] && . "${scripts_dir}/common.sh"

prop_replace 'nifi.web.http.port'              "${NIFI_WEB_HTTP_PORT:-8080}"
prop_replace 'nifi.web.http.host'              "${NIFI_WEB_HTTP_HOST:-$HOSTNAME}"


# Override JVM memory settings
if [ ! -z "${NIFI_JVM_HEAP_INIT}" ]; then
    prop_replace 'java.arg.2'       "-Xms${NIFI_JVM_HEAP_INIT}" ${nifi_bootstrap_file}
fi

if [ ! -z "${NIFI_JVM_HEAP_MAX}" ]; then
    prop_replace 'java.arg.3'       "-Xmx${NIFI_JVM_HEAP_MAX}" ${nifi_bootstrap_file}
fi

if [ ! -z "${NIFI_JVM_DEBUGGER}" ]; then
    uncomment "java.arg.debug" ${nifi_bootstrap_file}
fi

# Setup NiFi to use Python
uncomment "nifi.python.command" ${nifi_props_file}
prop_replace 'nifi.python.extensions.source.directory.default'  "${NIFI_HOME}/python_extensions"
# Setup NiFi to scan for new NARs in nar_extensions
prop_replace 'nifi.nar.library.autoload.directory'  "${NIFI_HOME}/nar_extensions"
# Establish baseline properties
prop_replace 'nifi.web.https.port'              ""
prop_replace 'nifi.web.https.host'              ""
prop_replace 'nifi.web.proxy.host'              "${NIFI_WEB_PROXY_HOST}"
prop_replace 'nifi.remote.input.host'           "${NIFI_REMOTE_INPUT_HOST:-$HOSTNAME}"
prop_replace 'nifi.remote.input.socket.port'    "${NIFI_REMOTE_INPUT_SOCKET_PORT:-10000}"
prop_replace 'nifi.remote.input.secure'         'false'
prop_replace 'nifi.cluster.protocol.is.secure'  'false'

# Set nifi-toolkit properties files and baseUrl
"${scripts_dir}/toolkit.sh"
prop_replace 'baseUrl' "http://${NIFI_WEB_HTTP_HOST}:${NIFI_WEB_HTTP_PORT}" ${nifi_toolkit_props_file}

prop_replace 'keystore'           ""      ${nifi_toolkit_props_file}
prop_replace 'keystoreType'       ""                              ${nifi_toolkit_props_file}
prop_replace 'truststore'         ""    ${nifi_toolkit_props_file}
prop_replace 'truststoreType'     ""                              ${nifi_toolkit_props_file}

if [ -z "${NIFI_WEB_PROXY_HOST}" ]; then
    echo 'NIFI_WEB_PROXY_HOST was not set but NiFi is configured to run in a secure mode. The NiFi UI may be inaccessible if using port mapping or connecting through a proxy.'
fi

prop_replace 'nifi.cluster.is.node'                         "${NIFI_CLUSTER_IS_NODE:-false}"
prop_replace 'nifi.cluster.node.address'                    "${NIFI_CLUSTER_ADDRESS:-$HOSTNAME}"
prop_replace 'nifi.cluster.node.protocol.port'              "${NIFI_CLUSTER_NODE_PROTOCOL_PORT:-}"
prop_replace 'nifi.cluster.node.protocol.max.threads'       "${NIFI_CLUSTER_NODE_PROTOCOL_MAX_THREADS:-50}"
prop_replace 'nifi.cluster.load.balance.host'               "${NIFI_CLUSTER_LOAD_BALANCE_HOST:-}"
prop_replace 'nifi.zookeeper.connect.string'                "${NIFI_ZK_CONNECT_STRING:-}"
prop_replace 'nifi.zookeeper.root.node'                     "${NIFI_ZK_ROOT_NODE:-/nifi}"
prop_replace 'nifi.cluster.flow.election.max.wait.time'     "${NIFI_ELECTION_MAX_WAIT:-5 mins}"
prop_replace 'nifi.cluster.flow.election.max.candidates'    "${NIFI_ELECTION_MAX_CANDIDATES:-}"
prop_replace 'nifi.web.proxy.context.path'                  "${NIFI_WEB_PROXY_CONTEXT_PATH:-}"

# Set leader election and state management properties
prop_replace 'nifi.cluster.leader.election.implementation'      "${NIFI_CLUSTER_LEADER_ELECTION_IMPLEMENTATION:-CuratorLeaderElectionManager}"
prop_replace 'nifi.state.management.provider.cluster'           "${NIFI_STATE_MANAGEMENT_PROVIDER_CLUSTER:-zk-provider}"

# Set analytics properties
prop_replace 'nifi.analytics.predict.enabled'                   "${NIFI_ANALYTICS_PREDICT_ENABLED:-false}"
prop_replace 'nifi.analytics.predict.interval'                  "${NIFI_ANALYTICS_PREDICT_INTERVAL:-3 mins}"
prop_replace 'nifi.analytics.query.interval'                    "${NIFI_ANALYTICS_QUERY_INTERVAL:-5 mins}"
prop_replace 'nifi.analytics.connection.model.implementation'   "${NIFI_ANALYTICS_MODEL_IMPLEMENTATION:-org.apache.nifi.controller.status.analytics.models.OrdinaryLeastSquares}"
prop_replace 'nifi.analytics.connection.model.score.name'       "${NIFI_ANALYTICS_MODEL_SCORE_NAME:-rSquared}"
prop_replace 'nifi.analytics.connection.model.score.threshold'  "${NIFI_ANALYTICS_MODEL_SCORE_THRESHOLD:-.90}"

# Set kubernetes properties
prop_replace 'nifi.cluster.leader.election.kubernetes.lease.prefix'  "${NIFI_CLUSTER_LEADER_ELECTION_KUBERNETES_LEASE_PREFIX:-}"

# Add NAR provider properties
# nifi-registry NAR provider
if [ -n "${NIFI_NAR_LIBRARY_PROVIDER_NIFI_REGISTRY_URL}" ]; then
    prop_add_or_replace 'nifi.nar.library.provider.nifi-registry.implementation' 'org.apache.nifi.registry.extension.NiFiRegistryExternalResourceProvider'
    prop_add_or_replace 'nifi.nar.library.provider.nifi-registry.url' "${NIFI_NAR_LIBRARY_PROVIDER_NIFI_REGISTRY_URL}"
fi

if [ -n "${NIFI_SENSITIVE_PROPS_KEY}" ]; then
    prop_replace 'nifi.sensitive.props.key' "${NIFI_SENSITIVE_PROPS_KEY}"
fi

if [ -n "${SINGLE_USER_CREDENTIALS_USERNAME}" ] && [ -n "${SINGLE_USER_CREDENTIALS_PASSWORD}" ]; then
    ${NIFI_HOME}/bin/nifi.sh set-single-user-credentials "${SINGLE_USER_CREDENTIALS_USERNAME}" "${SINGLE_USER_CREDENTIALS_PASSWORD}"
fi

. "${scripts_dir}/update_cluster_state_management.sh"




prop_replace 'nifi.security.keystore'           "${KEYSTORE_PATH}"
prop_replace 'nifi.security.keystoreType'       "${KEYSTORE_TYPE}"
prop_replace 'nifi.security.keystorePasswd'     "${KEYSTORE_PASSWORD}"
prop_replace 'nifi.security.keyPasswd'          "${KEY_PASSWORD:-$KEYSTORE_PASSWORD}"
prop_replace 'nifi.security.truststore'         "${TRUSTSTORE_PATH}"
prop_replace 'nifi.security.truststoreType'     "${TRUSTSTORE_TYPE}"
prop_replace 'nifi.security.truststorePasswd'   "${TRUSTSTORE_PASSWORD}"

prop_replace 'keystore'           "${KEYSTORE_PATH}"                    ${nifi_toolkit_props_file}
prop_replace 'keystoreType'       "${KEYSTORE_TYPE}"                    ${nifi_toolkit_props_file}
prop_replace 'keystorePasswd'     "${KEYSTORE_PASSWORD}"                ${nifi_toolkit_props_file}
prop_replace 'keyPasswd'          "${KEY_PASSWORD:-$KEYSTORE_PASSWORD}" ${nifi_toolkit_props_file}
prop_replace 'truststore'         "${TRUSTSTORE_PATH}"                  ${nifi_toolkit_props_file}
prop_replace 'truststoreType'     "${TRUSTSTORE_TYPE}"                  ${nifi_toolkit_props_file}
prop_replace 'truststorePasswd'   "${TRUSTSTORE_PASSWORD}"              ${nifi_toolkit_props_file}

echo "Nifi about to start"

# Continuously provide logs so that 'docker logs' can produce them
"${NIFI_HOME}/bin/nifi.sh" run &
nifi_pid="$!"
tail -F --pid=${nifi_pid} "${NIFI_HOME}/logs/nifi-app.log" &

trap 'echo Received trapped signal, beginning shutdown...;/opt/nifi/nifi-current/bin/nifi.sh stop;exit 0;' TERM HUP INT;
trap ":" EXIT

echo NiFi running with PID ${nifi_pid}.
wait ${nifi_pid}


