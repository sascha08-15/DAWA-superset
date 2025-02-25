FROM apache/nifi:2.2.0

USER root

ARG UID=1003
ARG GID=1003

# Modify existing nifi user and group
RUN groupmod -g ${GID} nifi && \
    usermod -u ${UID} -g ${GID} nifi && \
    chown -R ${UID}:${GID} /opt/nifi


USER ${UID}:${GID}