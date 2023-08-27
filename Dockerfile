FROM alpine:3.18.3

RUN apk add --no-cache bash curl

ENV CONFIG_FILE="/config/config.sh"

COPY entrypoint.sh cloudflare_dyndns.sh lib.sh /ddclient/

WORKDIR /ddclient
USER 1000
CMD ["/ddclient/entrypoint.sh"]
