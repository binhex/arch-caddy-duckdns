#!/usr/bin/dumb-init /bin/bash

# no config bind mount
if [[ ! -d "/config" ]]; then
	echo "[crit] /config bind mount not found, exiting..." ; exit 1
fi

# define config and database paths
caddy_install_path="/opt/caddy"
config_root="/config/caddy"
config_path="${config_root}/config"
data_path="${config_root}/data"
www_path="${config_root}/www"
www_filepath="${config_root}/www/index.html"
caddy_config_filepath="${config_path}/Caddyfile"
logs_path="${config_root}/logs"

# create config, database and cache paths
mkdir -p \
	"${config_root}" \
	"${config_path}" \
	"${data_path}" \
	"${www_path}" \
	"${logs_path}"

# copy stock Caddyfile if it doesn't exist
if [[ ! -f "${caddy_config_filepath}" ]]; then
	cp "/home/nobody/Caddyfile" "${caddy_config_filepath}"
fi

# create hello world webpage
if [[ ! -f "${www_filepath}" ]]; then
	echo "If you can see this message then Caddy is working correctly for HTTP - '${www_filepath}'" > "${www_filepath}"
fi

# run caddy with config file
"${caddy_install_path}/caddy" run --config "${caddy_config_filepath}"
