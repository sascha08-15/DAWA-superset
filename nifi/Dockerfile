FROM apache/nifi:2.2.0

USER root

ARG UID=1003
ARG GID=1003

# Modify existing nifi user and group
RUN groupmod -g ${GID} nifi && \
    usermod -u ${UID} -g ${GID} nifi && \
    chown -R ${UID}:${GID} /opt/nifi

# Declare volumes (they will be managed by Docker)
VOLUME /opt/nifi/nifi-current/flow_storage
VOLUME /opt/nifi/nifi-current/database

# Ensure correct permissions (will only apply if volumes are not mounted externally)
RUN chown -R nifi:nifi /opt/nifi/nifi-current/flow_storage
RUN chown -R nifi:nifi /opt/nifi/nifi-current/database

USER ${UID}:${GID}