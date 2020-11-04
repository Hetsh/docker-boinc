# BOINC
Simple to set up BOINC client.

## Running the server
```bash
docker run --detach --name boinc hetsh/boinc
```

## Stopping the container
```bash
docker stop boinc
```

## Configuring
The BOINC client can be configured via [boincmgr](https://boinc.berkeley.edu/wiki/BOINC_Manager) or [boinccmd](https://boinc.berkeley.edu/wiki/Boinccmd_tool).
Remote connections require addition parameter:
```bash
docker run ... hetsh/boinc --allow_remote_gui_rpc
```

## Creating persistent storage
```bash
STORAGE="/path/to/storage"
mkdir -p "$STORAGE"
chown -R 1366:1366 "$STORAGE"
```
`1366` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the storage directory.
Start the server with the additional mount flags:
```bash
docker run --mount type=bind,source=/path/to/storage,target=/boinc-data ...
```

## Time
Synchronizing the timezones will display the correct time in the logs.
The timezone can be shared with this mount flag:
```bash
docker run --mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-boinc).
```bash
systemctl enable boinc --now
```
By default, the systemd service assumes `/apps/boinc-data` for storage and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project hosted on [GitHub](https://github.com/Hetsh/docker-boinc).
Please feel free to ask questions, file an issue or contribute to it.