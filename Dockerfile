#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#

#
# Stage 1 : Builder
#
## Use 'gentkit/node' as the base image with specified version
## NOTE: If it is "unknown", cause the 'gentkit/node' base image to fail the build to ensure the correct version is referenced.
ARG NODE_IMAGE_TAG="unknown"
FROM gentkit/node:${NODE_IMAGE_TAG} AS builder

#
# Define build arguments for image metadata
#
ARG OPENCLAW_NPM_VERSION="unknown"

#
# Install OpenClaw and configure
#
RUN set -eu && \
    # install software \
    apk add --no-cache bash openssl git python3 py3-pip curl github-cli && \
    # install openclaw \
    npm i -g openclaw@${OPENCLAW_NPM_VERSION} --loglevel error --no-fund --no-audit && \
	# install depend libs \
    npm i -g @larksuiteoapi/node-sdk clawhub && \
    # install uv \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    # configure environment variables \
    echo -e "\
source \"$HOME/.local/bin/env\"" > /etc/profile.d/openclaw.sh && \
    # Create symbolic links (required by openclaw) \
    ln -sf /usr/local/node/bin/openclaw /usr/local/bin/openclaw && \
    # create directory \
    mkdir -p /etc/openclaw && \
    # clean npm cache \
    npm cache clean --force && \
    # delete temp files \
    rm -rf /tmp/* /var/tmp/* /root/.npm /root/.cache /var/cache/apk/*

# Copy resources
COPY --chmod=755 \
    scripts \
    /etc/openclaw/scripts

#
# Stage 2 : Production
#
FROM scratch AS production

#
# Copy resources
#
COPY --from=builder / /

#
# Set the working directory to /root for subsequent instructions
#
WORKDIR /root

#
# Expose port
#
EXPOSE 18789

#
# Set entrypoint
#
ENTRYPOINT ["/bin/bash", "-c", "/etc/openclaw/scripts/entrypoint.sh"]
