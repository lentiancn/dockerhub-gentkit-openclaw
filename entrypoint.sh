#!/bin/bash
#
# MIT License
#
# https://github.com/lentiancn/dockerhub-gentkit-openclaw/blob/main/LICENSE
#
set -e

if [ -z "$GATEWAY_AUTH" ]; then
  export GATEWAY_AUTH="token"
fi

if [ -z "$GATEWAY_TOKEN" ]; then
  export GATEWAY_TOKEN=$(openssl rand -hex 32)
fi

# Print version
echo "node $(node -v)"
echo "npm $(npm -v)"
echo "$(openclaw -v)"

if [ -f /tmp/docker_openclaw_configured.env ]; then
    source /tmp/docker_openclaw_configured.env
fi

# Perform one-time initialization for OpenClaw configuration
if [ "${openclaw_configured:false}" != "true" ]; then
  openclaw onboard \
  --non-interactive \
  --skip-health \
  --accept-risk \
  --mode local \
  --gateway-bind lan \
  --gateway-port 18789 \
  --gateway-auth "$GATEWAY_AUTH" \
  --gateway-token "$GATEWAY_TOKEN"
  echo "openclaw_configured=true" > /tmp/docker_openclaw_configured.env
  echo "OpenClaw configuration initialization completed."
fi

# Startup Gateway Service
exec openclaw gateway