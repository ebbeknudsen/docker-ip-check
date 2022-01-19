# docker-ip-check

A service which periodically checks your ip using ipconfig.io. You can costumize how often it runs, what to do when the IP changes, and what to do each time the ip-check runs.

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
```

By running the above the IP check runs every minute, and logs to docker logs. However to actually do something when the IP changes, you have to edit the `ip-changed-sh` script (see the configuration section below)

## Configuration
* Customize how often it runs by supplying the `CRON_EXPRESSION` environment variable to docker compose. Example: `- CRON_EXPRESSION=*/5 * * * *`
* Customize what to do when your IP changes by editing the `/scripts/ip-changed.sh` script file
* Customize what to do after ever IP check run by editing the `/scripts/ip-check-finished.sh` script file