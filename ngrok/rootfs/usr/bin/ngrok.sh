#!/usr/bin/with-contenv bashio
set -e
bashio::log.debug "Building ngrok.yml..."
configPath="/ngrok-config/ngrok.yml"
mkdir -p /ngrok-config
echo "log: stdout" > $configPath
echo "version: 2" >> $configPath

bashio::log.debug "Web interface port: $(bashio::addon.port 4040)"
if bashio::var.has_value "$(bashio::addon.port 4040)"; then
  echo "web_addr: 0.0.0.0:$(bashio::addon.port 4040)" >> $configPath
fi
if bashio::var.has_value "$(bashio::config 'log_level')"; then
  echo "log_level: $(bashio::config 'log_level')" >> $configPath
fi

if bashio::var.has_value "$(bashio::config 'auth_token')"; then
  echo "authtoken: $(bashio::config 'auth_token')" >> $configPath
fi
if bashio::var.has_value "$(bashio::config 'region')"; then
  echo "region: $(bashio::config 'region')" >> $configPath
else
  echo "No region defined, default region is US."
fi
echo $(bashio::config 'tunnels') >> $configPath

configfile=$(cat $configPath)
bashio::log.debug "Config file: \n${configfile}"
bashio::log.info "Starting ngrok..."
ngrok start --config $configPath --all
