FROM amd64/alpine:20220715
RUN echo "http://dl-5.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
        boinc=7.20.2-r0 \
        ca-certificates=20220614-r2

# App user
ARG APP_UID=1371
ARG APP_USER="boinc"
RUN sed -i "s|$APP_USER:x:[0-9]\+:|$APP_USER:x:$APP_UID:|" "/etc/group" && \
    sed -i "s|$APP_USER:x:[0-9]\+:[0-9]\+|$APP_USER:x:$APP_UID:$APP_UID|" "/etc/passwd"

# Volumes
ARG DATA_DIR="/boinc"
RUN mkdir "$DATA_DIR" && \
    chown "$APP_USER":"$APP_USER" "$DATA_DIR"
VOLUME ["$DATA_DIR"]

#      RPC
EXPOSE 31416/tcp

USER "$APP_USER"
WORKDIR "$DATA_DIR"
ENTRYPOINT ["boinc"]