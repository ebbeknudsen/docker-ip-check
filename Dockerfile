FROM ghcr.io/linuxserver/baseimage-alpine:3.15

RUN apk add --update \
        bash \
        curl \
    && rm -rf /var/cache/apk/*


ADD check-ip.sh entrypoint.sh /
ADD default-scripts/ip-changed.sh default-scripts/ip-check-finished.sh default-scripts/

RUN chmod +x check-ip.sh entrypoint.sh
RUN chmod +x default-scripts/ip-changed.sh default-scripts/ip-check-finished.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD crond -l 2 -f
