#!/bin/bash

set -e

basedir="$(dirname "${0}")"
source "${basedir}/lib.sh"

###############################################################################
# Variables with default value
CACHE_IPv6="${CACHE_IPv6:-$basedir/.cache_IPv6.txt}"
CACHE_IPv4="${CACHE_IPv4:-$basedir/.cache_IPv4.txt}"
# Needs to point to an instance of https://github.com/1rfsNet/Fritz-Box-Cloudflare-DynDNS
PROXY="${PROXY:-true}"
DEBUG="${DEBUG:-false}"
CONFIG_FILE="${CONFIG_FILE:-$basedir/config_cloudflare_dyndns.sh}"
#
###############################################################################

###############################################################################
# Variables without default value
# Need PASSWORD, SERVER and at least one of the DOMAIN variables
DOMAINS="${DOMAINS:-}"
DOMAINS_IPv6="${DOMAINS_IPv6:-}"
DOMAINS_IPv4="${DOMAINS_IPv4:-}"
PASSWORD="${PASSWORD:-}"
SERVER="${SERVER:-}"
#
###############################################################################

if [ -e "${CONFIG_FILE}" ]; then
	# shellcheck disable=SC1090
	source "${CONFIG_FILE}"
fi

if [[ "${DOMAINS}" == "" && "${DOMAINS_IPv6}" == "" && "${DOMAINS_IPv4}" == "" ]]; then
	error "No DOMAINS configured"
fi

if [ "${PASSWORD}" == "" ]; then
	error "No PASSWORD configured"
fi

if [ "${SERVER}" == "" ]; then
	error "No SERVER configured"
fi

proxy=""
if [ "$PROXY" == "true" ]; then
	proxy="&proxy=true"
fi

myIPv6="$(get_ipv6)"
oldIPv6=""

myIPv4="$(get_ipv4)"
oldIPv4=""

debug "myIPv6 is \"${myIPv6}\""
debug "checking old ips"

rc=0
oldIPv4="$(get_cache "${CACHE_IPv4}")" || rc=$?
[[ $rc -ne 0 ]] && echo "Failed to read old ip: ${oldIPv4}" && exit $rc

rc=0
oldIPv6="$(get_cache "${CACHE_IPv6}")" || rc=$?
[[ $rc -ne 0 ]] && echo "Failed to read old ip: ${oldIPv6}" && exit $rc

debug "oldIPv6 is \"${oldIPv6}\""
debug "checking if update is necessary"

base_url="${SERVER}?cf_key=${PASSWORD}${proxy}"

if [ "${myIPv6}" != "${oldIPv6}" ] || [ "${myIPv4}" != "${oldIPv4}" ]; then
	rc=0
	if [ "${DOMAINS}" != "" ]; then
		echo "Updating domain(s) '${DOMAINS}' to '${myIPv4}' and '${myIPv6}' from '${oldIPv4}' and '${oldIPv6}'"
		response="$(curl --silent "${base_url}&domain=${DOMAINS}&ipv4=${myIPv4}&ipv6=${myIPv6}")"
		if [ "${response}" == "Result: success" ]; then
			echo "update successfull"
		else
			echo "Failed to update domains(s): ${DOMAINS}"
			echo "Response from server: ${response}"
			rc=1
		fi
	fi
	if [ "${DOMAINS_IPv4}" != "" ] && [ "${myIPv4}" != "${oldIPv4}" ]; then
		echo "Updating domain(s) '${DOMAINS_IPv4}' to '${myIPv4}' from '${oldIPv4}'"
		response="$(curl --silent "${base_url}&domain=${DOMAINS_IPv4}&ipv4=${myIPv4}")"
		if [ "${response}" == "Result: success" ]; then
			echo "update successfull"
		else
			echo "Failed to update domains(s): ${DOMAINS_IPv4}"
			echo "Response from server: ${response}"
			rc=1
		fi
	fi
	if [ "${DOMAINS_IPv6}" != "" ] && [ "${myIPv6}" != "${oldIPv6}" ]; then
		echo "Updating domain(s) '${DOMAINS_IPv6}' to '${myIPv6}' from '${oldIPv6}'"
		response="$(curl --silent "${base_url}&domain=${DOMAINS_IPv6}&ipv6=${myIPv6}")"
		if [ "${response}" == "Result: success" ]; then
			echo "update successfull"
		else
			echo "Failed to update domains(s): ${DOMAINS_IPv6}"
			echo "Response from server: ${response}"
			rc=1
		fi
	fi
	[[ $rc -ne 0 ]] && exit $rc
	# shellcheck disable=SC2320
	echo "${myIPv4}" >"${CACHE_IPv4}" || rc=$?
	[[ $rc -ne 0 ]] && echo "Failed to save new ip: ${myIPv4}" && exit $rc
	echo "Written IPv4 to cache"
	# shellcheck disable=SC2320
	echo "${myIPv6}" >"${CACHE_IPv6}" || rc=$?
	[[ $rc -ne 0 ]] && echo "Failed to save new ip: ${myIPv6}" && exit $rc
	echo "Written IPv6 to cache"
fi
