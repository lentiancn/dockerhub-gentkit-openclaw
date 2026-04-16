#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#

#
# Stage 1 : builder
#
# NOTE: If it is "unknown", cause the 'gentkit/node' base image to fail the build to ensure the correct version is referenced.
#
ARG NODE_IMAGE_TAG="unknown"

#
# Use 'gentkit/node' as the base image with specified version
#
FROM gentkit/node:${NODE_IMAGE_TAG} AS builder

#
# Define build arguments for image metadata
#
ARG NODE_IMAGE_TAG="unknown"
ARG OPENCLAW_NPM_VERSION="unknown"

RUN set -eux && \
    # install software
    apk add --no-cache git && \
    # install openclaw
    npm i -g openclaw@${OPENCLAW_NPM_VERSION} --loglevel error --no-fund --no-audit && \
	# install depend libs
    #npm i -g @buape/carbon @larksuiteoapi/node-sdk @slack/web-api @slack/bolt grammy && \
	# clean npm cache
    npm cache clean --force && \
    # delete temp files
    rm -rf /tmp/* /var/tmp/* /root/.npm /root/.cache

#
# Stage 2 : production
#
FROM gentkit/node:${NODE_IMAGE_TAG} AS production

#
# Define build arguments for image metadata
#
ARG OPENCLAW_IMAGE_VERSION="unknown"
ARG OPENCLAW_IMAGE_BUILD_DATE="unknown"

#
# Image metadata labels following OCI Image Format Specification
#
LABEL maintainer="Len <lentiancn@126.com>" \
      description="A lightweight Docker image for quick and easy deployment of OpenClaw ("lobster🦞" AI Agent)." \
      org.opencontainers.image.title="OpenClaw on Docker" \
      org.opencontainers.image.description="A lightweight Docker image for quick and easy deployment of OpenClaw ("lobster🦞" AI Agent)." \
      org.opencontainers.image.vendor="GentKit" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/lentiancn/docker-gentkit-openclaw" \
      org.opencontainers.image.version="${OPENCLAW_IMAGE_VERSION}" \
      org.opencontainers.image.created="${OPENCLAW_IMAGE_BUILD_DATE}"

#
# Copy resources
#
COPY --from=builder /usr/local/node/lib/node_modules/openclaw /usr/local/node/lib/node_modules/openclaw
COPY --from=builder /usr/local/node/bin/openclaw /usr/local/node/bin/openclaw

#
# Configure node
#
RUN set -eux && \
    apk add --no-cache bash openssl git && \
    #apk add --no-cache bash curl openssl net-tools && \
    # create group and user
    addgroup -g 6001 -S openclaw && \
    adduser -u 6001 -S openclaw -G openclaw -h /home/openclaw && \
    mkdir -p /usr/local/docker

#
# Copy scripts
#
COPY --chmod=755 scripts /usr/local/docker/scripts

#
# Expose port
#
EXPOSE 18789

#
# Set user
#
USER openclaw

#
# Set working directory
#
WORKDIR /home/openclaw

#
# Set entrypoint
#
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/docker/scripts/entrypoint.sh"]