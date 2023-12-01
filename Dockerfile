FROM docker.io/library/alpine:3.18.5@sha256:34871e7290500828b39e22294660bee86d966bc0017544e848dd9a255cdf59e0

RUN apk add --no-cache bash curl

ENV CONFIG_FILE="/config/config.sh"

COPY entrypoint.sh cloudflare_dyndns.sh lib.sh /ddclient/

WORKDIR /ddclient
USER 1000
CMD ["/ddclient/entrypoint.sh"]
