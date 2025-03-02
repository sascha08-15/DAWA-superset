FROM apache/nifi:2.2.0

USER nifi

RUN mkdir /opt/nifi/nifi-current/flow_storage
RUN mkdir /opt/nifi/nifi-current/database

# Declare volumes (they will be managed by Docker)
VOLUME /opt/nifi/nifi-current/flow_storage /opt/nifi/nifi-current/database

USER root

ARG UID=1003
ARG GID=1003

# Modify existing nifi user and group
RUN groupmod -g ${GID} nifi && \
    usermod -u ${UID} -g ${GID} nifi && \
    chown -R ${UID}:${GID} ${NIFI_BASE_DIR} && \
    chown -R nifi:nifi ${NIFI_HOME}

USER ${UID}:${GID}


