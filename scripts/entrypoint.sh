#!/bin/bash
#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#
set -e

# Initialize
source /usr/local/docker/scripts/init.sh

# Print version
echo "node $(node -v)"
echo "npm $(npm -v)"
echo "$(openclaw -v)"

# Run OpenClaw gateway
exec openclaw gateway