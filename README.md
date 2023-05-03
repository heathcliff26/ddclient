# ddclient for cloudflare

This ddclient script is the client side https://github.com/1rfsNet/Fritz-Box-Cloudflare-DynDNS.
For deploying it, a server endpoint is needed.

It is designed to work as a cronjob.

## Setup

For setting up the script, copy the [example config](examples/config_cloudflare_dyndns.sh) and set your configuration.

By default the script will source the config file in the same folder as the script as `config_cloudflare_dyndns.sh`.

Additional config options that can be added to the config file are:
```
# Cache where the current IPv4/6 address is stored to avoid unnecessary calls to the server.
CACHE_IPv6="${CACHE_IPv6:-$basedir/.cache_IPv6.txt}"
CACHE_IPv4="${CACHE_IPv4:-$basedir/.cache_IPv4.txt}"
# Config file to source
CONFIG_FILE="${CONFIG_FILE:-$basedir/config_cloudflare_dyndns.sh}"
```

For running the script regulary, setup a cronjob with `crontab -e`.

Example:
```
*/5 * * * * /ddclient/cloudflare_dyndns.sh
```
This will run the script every 5 minutes.

### Troubleshooting

Make sure the config file is executable.

## Other scripts

Other things i have for ddclient stuff:

1. There are configuration files for the ddclient package against strato under the examples.

2. The script `monitorIPv6.sh` can be used to monitor ULA IPv6 addresses. For example with the prefix `fd00::`.