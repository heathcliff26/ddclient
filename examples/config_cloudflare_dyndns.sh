#!/bin/bash
# shellcheck disable=SC2034

# Enable debug message, used for testing only
DEBUG="false"
# Set proxy to true for all entries
PROXY="true"

# You can use multiple domains separated by ' ' in the DOMAIN variables.
# While the are not mutually exclusive, having the same domain in multiple variables will either
# result in both A and AAAA entries or might lead to unpredictable behaviour.
#
# Domain used for both A and AAAA entries
DOMAINS=""
# Generates AAAA DNS only
DOMAINS_IPv6=""
# Generate A DNS only
DOMAINS_IPv4=""
# Cloudflare token
PASSWORD=""
# Needs to point to an instance of https://github.com/1rfsNet/Fritz-Box-Cloudflare-DynDNS
SERVER=""
