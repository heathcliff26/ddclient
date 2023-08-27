#!/bin/bash

set -e

basedir="$(dirname "${0}")"
# shellcheck source=./lib.sh
source "${basedir}/lib.sh"

###############################################################################
# Variables with default value
CACHE_IPv6="${CACHE_IPv6:-$basedir/.cache_monitorIPv6.txt}"
DEBUG="${DEBUG:-false}"
CONFIG_FILE="${CONFIG_FILE:-$basedir/config_monitorIPv6.sh}"

HOSTNAME="${HOSTNAME:-$(/bin/hostname)}"
#
###############################################################################

###############################################################################
# Variables without default value
# Need MAILTO variable
MAILTO="${MAILTO:-}"
#
###############################################################################

if [ -e "${CONFIG_FILE}" ]; then
	# shellcheck disable=SC1090
	source "${CONFIG_FILE}"
fi

if [ "${MAILTO}" == "" ]; then
	error "No MAILTO configured"
fi

# Syntax for ULA ip
myIPv6="$(/sbin/ip -6 addr | grep inet6 | awk -F '[ \t]+|/' '{print $3}' | grep -x -v 'fd00::3' | grep 'fd00')"
# Syntax for puplic ip
#myIPv6="$(get_ipv6)"

oldIPv6=""

debug "myIPv6 is \"${myIPv6}\""
debug "checking old ip"

rc=0
oldIPv6="$(get_cache "${CACHE_IPv6}")" || rc=$?
[[ $rc -eq 0 ]] || send_error "Failed to read old ip: ${oldIPv6}" $rc

debug "oldIPv6 is \"${oldIPv6}\""
debug "checking if update is necessary"

if [ "${myIPv6}" != "${oldIPv6}" ]; then
	echo -e "IPv6 changed from ${oldIPv6} to ${myIPv6}" | mail -s "[${HOSTNAME}] IPv6 Address changed" "$MAILTO"
	rc=0
	# shellcheck disable=SC2320
	echo "${myIPv6}" >"${CACHE_IPv6}" || rc=$?
	[[ $rc -eq 0 ]] || send_error "Failed to save new ip: ${myIPv6}" $rc
fi
