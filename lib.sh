#!/bin/bash

# Write debug messages
function debug {
    if [ "${DEBUG}" == "true" ]; then
        echo "DEBUG: ${*}"
    fi
}

function send_error {
    echo "ERROR: ${1}" | mail -s "[${HOSTNAME}] Monitoring IPv6 failed" "$MAILTO"
    exit "${2}"
}

function error {
    echo "ERROR: ${1}"
    exit "${2:-1}"
}

function get_ipv4 {
    curl --ipv4 -s ipv4.icanhazip.com
}

function get_ipv6 {
    if [ "${DUAL_STACK}" == "true" ]; then
        curl --ipv6 -s ipv6.icanhazip.com
    fi
}

function get_cache {
    if [ -f "${1}" ]; then
        cat "${1}"
        return $?
    fi
    return 0
}
