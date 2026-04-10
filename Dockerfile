#
# MIT License
#
# https://github.com/lentiancn/dockerhub-gentkit-openclaw/blob/main/LICENSE
#

# stage-1
FROM node:25.9.0-alpine3.23 AS builder

RUN set -eux && \
    # install software
    apk add --no-cache bash openssl curl net-tools git make g++ cmake python3 && \
    # install openclaw and depend libs
    npm i -g openclaw --loglevel error --no-fund --no-audit && \
	# install depend libs
    #npm i -g @buape/carbon @larksuiteoapi/node-sdk @slack/web-api @slack/bolt grammy && \
	# clean npm cache
    npm cache clean --force && \
    # delete temp files
    rm -rf /tmp/* /var/tmp/* /root/.npm /root/.cache

# stage-2
FROM node:25.9.0-alpine3.23

ARG IMAGE_VERSION=1.0.1-beta

LABEL maintainer="Len <lentiancn@126.com>" \
      description="A lightweight Docker image for quick and easy deployment of OpenClaw (\"lobster\" AI Agent)." \
      org.opencontainers.image.title="OpenClaw Gateway" \
      org.opencontainers.image.description="A lightweight Docker image for quick and easy deployment of OpenClaw (\"lobster\" AI Agent)." \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.source="https://github.com/lentiancn/dockerhub-gentkit-openclaw" \
      org.opencontainers.image.licenses="MIT"

RUN set -eux && \
    apk add --no-cache bash curl openssl net-tools && \
    # create group and user
    addgroup -g 6001 -S openclaw && \
    adduser -u 6001 -S openclaw -G openclaw -h /home/openclaw && \
    mkdir -p /usr/local/docker

COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin /usr/local/bin

COPY --chmod=755 entrypoint.sh /usr/local/docker/entrypoint.sh

EXPOSE 18789

USER openclaw

WORKDIR /home/openclaw

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/docker/entrypoint.sh"]