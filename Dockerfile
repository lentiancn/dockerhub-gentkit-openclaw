#
# MIT License
#
# https://github.com/lentiancn/docker-gentkit-openclaw/blob/main/LICENSE
#

#
# NOTE: If it is "unknown", cause the 'gentkit/node' base image to fail the build to ensure the correct version is referenced.
#
ARG NODE_IMAGE_VERSION="unknown"

#
# Use 'gentkit/node' as the base image with specified version
#
FROM gentkit/node:${NODE_IMAGE_VERSION}

#
# Define build arguments for image metadata
#
ARG IMAGE_VERSION="unknown"
ARG IMAGE_BUILD_DATE="unknown"

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
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.created="${IMAGE_BUILD_DATE}"

RUN set -x && \
    # install software
    apk add --no-cache bash openssl curl net-tools && \
	# install openclaw and depend libs
    npm i -g openclaw @buape/carbon @larksuiteoapi/node-sdk @slack/web-api @slack/bolt grammy && \
	# create group and user
    addgroup -g 6001 -S openclaw && \
    adduser -u 6001 -S openclaw -G openclaw -h /home/openclaw && \
	# clean npm cache
    npm cache clean --force && \
    # delete temp files
    rm -rf /tmp/* /var/tmp/* && \
	# create directory for docker
	mkdir -p /usr/local/docker

COPY --chmod=755 entrypoint.sh /usr/local/docker/entrypoint.sh

EXPOSE 18789

USER openclaw

WORKDIR /home/openclaw

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/docker/entrypoint.sh"]