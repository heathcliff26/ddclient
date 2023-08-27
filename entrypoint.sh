#!/bin/bash

set -e

export CACHE_IPv6="/tmp/.cache_ddclient_ipv6"
export CACHE_IPv4="/tmp/.cache_ddclient_ipv4"

# Time in minutes to wait between script executions
DELAY="${DELAY:-5}"

if [ "${DELAY}" -lt "1" ]; then
    echo "Wrong input for DELAY, needs to be at least 1, input DELAY=${DELAY}"
fi

echo "Starting ddclient"
while true; do
    /ddclient/cloudflare_dyndns.sh || echo "Failed to run cloudflare_dyndns.sh script, exited with rc=$?"
    sleep "${DELAY}m"
done
