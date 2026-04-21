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
ARG OPENCLAW_IMAGE_VERSION="unknown"
ARG OPENCLAW_IMAGE_BUILD_DATE="unknown"
ARG OPENCLAW_NPM_VERSION="unknown"

#
# Install OpenClaw and configure
#
RUN set -eu && \
    # install software \
    apk add --no-cache bash openssl git && \
    # install openclaw \
    npm i -g openclaw@${OPENCLAW_NPM_VERSION} --loglevel error --no-fund --no-audit && \
	# install depend libs \
    #npm i -g @buape/carbon @larksuiteoapi/node-sdk @slack/web-api @slack/bolt grammy && \
    # clean npm cache \
    npm cache clean --force && \
    # delete temp files \
    rm -rf /tmp/* /var/tmp/* /root/.npm /root/.cache /var/cache/apk/* && \
    ## Create symbolic links (required by openclaw) \
    ln -sf /usr/local/node/bin/openclaw /usr/local/bin/openclaw && \
    # create group and user \
    addgroup -g 6001 -S openclaw && \
    adduser -u 6001 -S openclaw -G openclaw -h /home/openclaw && \
    # create directory \
    mkdir -p /etc/docker/scripts

# Copy resources
COPY --chmod=755 \
    scripts/* \
    /etc/docker/scripts/

#
# Set user
#
USER openclaw

#
# Set working directory
#
WORKDIR /home/openclaw

#
# Expose port
#
EXPOSE 18789

#
# Set entrypoint
#
ENTRYPOINT ["/bin/bash", "-c", "/etc/docker/scripts/entrypoint.sh"]