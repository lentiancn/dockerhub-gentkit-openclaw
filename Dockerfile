#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#

#
# Use 'gentkit/node' as the base image with specified version
#
# NOTE: If it is "unknown", cause the 'gentkit/node' base image to fail the build to ensure the correct version is referenced.
#
ARG NODE_IMAGE_TAG="unknown"
FROM gentkit/node:${NODE_IMAGE_TAG}

#
# Define build arguments for image metadata
#
ARG OPENCLAW_NPM_VERSION="unknown"

#
# Install OpenClaw and configure
#
RUN set -eu && \
    # install software \
    apk add --no-cache bash openssl git python3 py3-pip curl && \
    # install openclaw \
    npm i -g openclaw@${OPENCLAW_NPM_VERSION} --loglevel error --no-fund --no-audit && \
	# install depend libs \
    npm i -g @larksuiteoapi/node-sdk github-cli && \
    # install jq depended by session-logs \
    npm i -g jq && \
    # install uv \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    # clean npm cache \
    npm cache clean --force && \
    # delete temp files \
    rm -rf /tmp/* /var/tmp/* /root/.npm /root/.cache /var/cache/apk/* && \
    ## Create symbolic links (required by openclaw) \
    ln -sf /usr/local/node/bin/openclaw /usr/local/bin/openclaw && \
    # create directory \
    mkdir -p /etc/openclaw

# Copy resources
COPY --chmod=755 \
    scripts \
    /etc/openclaw/scripts

#
# Expose port
#
EXPOSE 18789

#
# Set entrypoint
#
ENTRYPOINT ["/bin/bash", "-c", "/etc/openclaw/scripts/entrypoint.sh"]