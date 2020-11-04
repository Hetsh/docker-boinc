FROM library/alpine:20200917
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    boinc@testing=7.16.1-r2 \
    ca-certificates=20191127-r5

# App user
ARG APP_UID=1371
ARG APP_USER="boinc"
RUN sed -i "s|$APP_USER:x:[0-9]\+:|$APP_USER:x:$APP_UID:|" "/etc/group" && \
    sed -i "s|$APP_USER:x:[0-9]\+:[0-9]\+|$APP_USER:x:$APP_UID:$APP_UID|" "/etc/passwd"

# Config & Volumes
ARG DATA_DIR="/boinc-data"
RUN mkdir "$DATA_DIR" && \
    echo -e "<cc_config>\n  <log_flags>\n    <task>1</task>\n    <file_xfer>1</file_xfer>\n    <sched_ops>1</sched_ops>\n  </log_flags>\n</cc_config>" > "$DATA_DIR/cc_config.xml" && \
    chown -R "$APP_USER":"$APP_USER" "$DATA_DIR" && \
    ln -s "/etc/ssl/certs/ca-certificates.crt" "$DATA_DIR/ca-bundle.crt"
VOLUME ["$DATA_DIR"]

#      RPC
EXPOSE 31416/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["boinc"]