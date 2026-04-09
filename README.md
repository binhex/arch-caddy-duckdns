# Application

[Caddy](https://caddyserver.com/)

## Description

Caddy is a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go.
This image includes the DuckDNS DNS challenge plugin, enabling automatic TLS certificate issuance
and renewal via Let's Encrypt for DuckDNS hostnames without requiring port 80 to be open. Ideal
for use as a reverse proxy on a home network.

## Build notes

Latest GitHub release.

## Usage

```bash
docker run -d \
        --name=<container name> \
        -p <https port>:8443 \
        -p <http port>:8080 \
        -p <admin port>:2019 \
        -v <path for config files>:/config \
        -v /etc/localtime:/etc/localtime:ro \
        -e DUCKDNS_TOKEN=<your duckdns token> \
        -e ENABLE_HEALTHCHECK=<yes|no> \
        -e HEALTHCHECK_COMMAND=<command> \
        -e HEALTHCHECK_ACTION=<action> \
        -e HEALTHCHECK_HOSTNAME=<hostname> \
        -e UMASK=<umask for created files> \
        -e PUID=<uid for user> \
        -e PGID=<gid for user> \
        ghcr.io/binhex/arch-caddy-duckdns
```

Please replace all user variables in the above command defined by <> with the
correct values.

## Access application

`http://<host ip>:8080`

## Caddyfile

Place your Caddyfile at `/config/caddy/Caddyfile`. An example Caddyfile with commented-out
reverse proxy configurations is provided on first run at this location. The global block
must define `http_port` and `https_port` to match the ports mapped above, e.g.:-

```caddy
{
    http_port 8080
    https_port 8443
}
```

Your DuckDNS token should be passed in via the `DUCKDNS_TOKEN` environment variable and
referenced in your Caddyfile as `{env.DUCKDNS_TOKEN}`, e.g.:-

```caddy
mydomain.duckdns.org:8443 {
    tls {
        dns duckdns {env.DUCKDNS_TOKEN}
    }
    reverse_proxy my-server-ip:8096
}
```

See the example Caddyfile at `/config/caddy/Caddyfile` for subdomain, root base URL and
app base URL reverse proxy configurations.

## Example

```bash
docker run -d \
        --name=caddy-duckdns \
        -p 8443:8443 \
        -p 8080:8080 \
        -p 2019:2019 \
        -v /apps/docker/caddy-duckdns:/config \
        -v /etc/localtime:/etc/localtime:ro \
        -e DUCKDNS_TOKEN=your-duckdns-token \
        -e ENABLE_HEALTHCHECK=yes \
        -e UMASK=000 \
        -e PUID=99 \
        -e PGID=100 \
        ghcr.io/binhex/arch-caddy-duckdns
```

## Notes

- Your DuckDNS token can be found by logging into [DuckDNS](https://www.duckdns.org/).
- Caddy stores Let's Encrypt account data and certificates under `/home/nobody/.local/share/caddy/`
    inside the container — ensure `/config` is mapped to a persistent volume to avoid
    re-registration on restart.
- The admin API endpoint on port `2019` is optional; it allows runtime configuration via the
    [Caddy API](https://caddyserver.com/docs/api).
- Logs are written to `/config/caddy/logs/access.log`.

User ID (PUID) and Group ID (PGID) can be found by issuing the following
command for the user you want to run the container as:-

```bash
id <username>
```

___
If you appreciate my work, then please consider buying me a beer  :D

[![PayPal donation](https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=MM5E27UX6AUU4)

[Documentation](https://github.com/binhex/documentation) | [Support forum](https://forums.unraid.net/topic/198200-support-binhex-caddy-duckdns/)
