# docker-ip-check

A service which periodically checks your ip using ipconfig.io. You can costumize how often it runs, what to do when the IP changes, and what to do each time the ip-check runs.

## Features
* Checks IP using ipconfig.io (can be changed with environment variable `CHECK_IP_CMD`)
* Fallback to check IP using api.ipify.org if primary check doesn't return a valid IP (can be changed with environment variable `CHECK_IP_CMD_FALLBACK`)
* Run script when IP changes (by customizing `ip-changed.sh`)
* Run script after every check (by customizing `ip-check-finished.sh`) 

## Run with docker compose
```yaml
services:
  ip-check:
    image: ip-check:latest
    container_name: ip-check
    restart: unless-stopped
    volumes:
      - ${DATADIR}/ip-check:/scripts
    environment:
      - PUID=$PUID # Your userid (uid)
      - PGID=$PGID # Your groupid (gid)
      - CRON_EXPRESSION=*/1 * * * * # Optional, default value is shown (runs every minute)
      - CHECK_IP_CMD=curl -fsS -m 5 --retry 5 ipconfig.io 2>&1 # Optional, default value is shown
      - CHECK_IP_CMD_FALLBACK=curl -fsS -m 5 --retry 5 api.ipify.org 2>&1 # Optional, default value is shown. Set to empty string to disable fallback check
```

By running the above the IP check runs every minute, and logs to docker logs. However to actually do something when the IP changes, you have to edit the `ip-changed-sh` script (see the configuration section below)

## Configuration
* Customize how often it runs by supplying the `CRON_EXPRESSION` environment variable to docker compose. Example: `- CRON_EXPRESSION=*/5 * * * *`
* Customize the IP check command by supplying the `CHECK_IP_CMD` environment variable to docker compose
* Customize the IP check fallback command by supplying the `CHECK_IP_CMD_FALLBACK` environment variable to docker compose (set to empty string to disable fallback check)
* Customize what to do when your IP changes by editing the `${DATADIR}/ip-check/ip-changed.sh` script file. The IP's are provided as arguments to the script (eg. `NEW_IP=$1` and `OLD_IP=$2`)
* Customize what to do after every IP check run by editing the `${DATADIR}/ip-check/ip-check-finished.sh` script file. The IP's are provided as arguments to the script (eg. `CURRENT_IP=$1` and `OLD_IP=$2`)