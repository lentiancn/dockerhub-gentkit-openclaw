#!/bin/bash
#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#
set -e

# Load openclaw onboard-init.profile
if [ -f /etc/openclaw/onboard-init.profile ]; then
    source /etc/openclaw/onboard-init.profile
fi

# Perform one-time initialization for OpenClaw onboard
if [ "${OPENCLAW_ONBOARD_INITIALIZED:false}" != "true" ]; then
  if [ -z "${GATEWAY_BIND}" ]; then
    export GATEWAY_BIND="lan"
  fi

  export GATEWAY_PORT=18789

  if [ -z "${GATEWAY_AUTH}" ]; then
    export GATEWAY_AUTH="token"
  fi

  if [ -z "${GATEWAY_TOKEN}" ]; then
    export GATEWAY_TOKEN=$(openssl rand -hex 32)
  fi

  # Run OpenClaw onboard
  openclaw onboard \
  --non-interactive \
  --skip-health \
  --accept-risk \
  --mode local \
  --gateway-bind "${GATEWAY_BIND}" \
  --gateway-port ${GATEWAY_PORT} \
  --gateway-auth "${GATEWAY_AUTH}" \
  --gateway-token "${GATEWAY_TOKEN}"

  # Store to openclaw onboard-init.profile
  echo "export OPENCLAW_ONBOARD_INITIALIZED=true" > /etc/openclaw/onboard-init.profile
  echo "OpenClaw onboard initialization completed successfully."
fi