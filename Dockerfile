FROM library/debian:stable-20201012-slim
RUN DEBIAN_FRONTEND="noninteractive" && \
    apt-get update && \
    apt-get install --no-install-recommends --assume-yes \
        boinc-client=7.14.2+dfsg-3 && \
        rm -r "/var/lib/boinc" "/var/lib/boinc-client" && \
    rm -r /var/lib/apt/lists /var/cache/apt

# App user
ARG APP_UID=1366
ARG APP_USER="boinc"
RUN sed -i "s|$APP_USER:x:[0-9]\+:|$APP_USER:x:$APP_UID:|" "/etc/group" && \
    sed -i "s|$APP_USER:x:[0-9]\+:[0-9]\+|$APP_USER:x:$APP_UID:$APP_UID|" "/etc/passwd"

# Config & Volumes
ARG DATA_DIR="/boinc-data"
RUN mv "/etc/boinc-client" "$DATA_DIR" && \
    chown "$APP_USER" "$DATA_DIR" "$DATA_DIR/cc_config.xml" && \
    chgrp -R "$APP_USER" "$DATA_DIR" && \
    ln -s "/etc/ssl/certs/ca-certificates.crt" "$DATA_DIR/ca-bundle.crt"
VOLUME ["$DATA_DIR"]

#      RPC
EXPOSE 31416/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["boinc"]