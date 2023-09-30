FROM docker.io/library/alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978

RUN apk add --no-cache bash curl

ENV CONFIG_FILE="/config/config.sh"

COPY entrypoint.sh cloudflare_dyndns.sh lib.sh /ddclient/

WORKDIR /ddclient
USER 1000
CMD ["/ddclient/entrypoint.sh"]
