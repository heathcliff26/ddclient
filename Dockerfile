FROM docker.io/library/alpine:3.19.0@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48

RUN apk add --no-cache bash curl

ENV CONFIG_FILE="/config/config.sh"

COPY entrypoint.sh cloudflare_dyndns.sh lib.sh /ddclient/

WORKDIR /ddclient
USER 1000
CMD ["/ddclient/entrypoint.sh"]
