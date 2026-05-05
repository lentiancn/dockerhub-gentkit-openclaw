#!/bin/bash
#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#
set -e

# Load environment variables
source /etc/profile.d/openclaw.sh

# Initialize
source /etc/openclaw/scripts/init.sh

# Run OpenClaw gateway
exec openclaw gateway