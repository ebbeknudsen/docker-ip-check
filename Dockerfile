FROM alpine:latest

RUN apk add --update \
        bash \
        curl \
    && rm -rf /var/cache/apk/*

ADD check-ip.sh entrypoint.sh /
ADD default-scripts/ip-changed.sh default-scripts/ip-check-finished.sh /default-scripts/

RUN chmod +x /check-ip.sh /entrypoint.sh
RUN chmod +x /default-scripts/ip-changed.sh /default-scripts/ip-check-finished.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD crond -l 2 -f
