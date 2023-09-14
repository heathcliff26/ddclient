#!/bin/bash

set -e

export CACHE_IPv6="/tmp/.cache_ddclient_ipv6"
export CACHE_IPv4="/tmp/.cache_ddclient_ipv4"

# Time in minutes to wait between script executions
DELAY="${DELAY:-5}"

if [ "${DELAY}" -lt "1" ]; then
    echo "Wrong input for DELAY, needs to be at least 1, input DELAY=${DELAY}"
fi

# Create DOMAINS if running inside kubernetes
if [[ -n "${NODE_NAME}" && -n "${BASE_DOMAIN}" && -z "${DOMAINS}" ]]; then
    export DOMAINS="${NODE_NAME}.${BASE_DOMAIN}"
    echo "Set DOMAINS to \"${DOMAINS}\""
fi

echo "Starting ddclient"
error_count=0
while true; do
    rc=0
    /ddclient/cloudflare_dyndns.sh || rc=$?
    if [ $rc -ne 0 ]; then
        echo "Failed to run cloudflare_dyndns.sh script, exited with rc=$rc"
        error_count=$((error_count + 1))
        if [ $error_count -ge 5 ]; then
            echo "Too many failed script executions, exiting"
            exit $rc
        else
            echo "error_count is at ${error_count}"
            echo "Retrying in 5s"
            sleep "5s"
            continue
        fi
    elif [ $error_count -ne 0 ]; then
        echo "Script was successfull, reseting error_count"
        error_count=0
    fi
    sleep "${DELAY}m"
done
