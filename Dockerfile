FROM docker.io/library/alpine:3.18.3@sha256:7144f7bab3d4c2648d7e59409f15ec52a18006a128c733fcff20d3a4a54ba44a

RUN apk add --no-cache bash curl

ENV CONFIG_FILE="/config/config.sh"

COPY entrypoint.sh cloudflare_dyndns.sh lib.sh /ddclient/

WORKDIR /ddclient
USER 1000
CMD ["/ddclient/entrypoint.sh"]
