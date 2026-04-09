#
# MIT License
#
# https://github.com/lentiancn/dockerhub-gentkit-openclaw/blob/main/LICENSE
#
FROM node:25.9.0-alpine3.23

ARG IMAGE_VERSION=1.0.0

LABEL maintainer="Len <lentiancn@126.com>" \
      description="A lightweight Docker image for quick and easy deployment of OpenClaw (\"lobster\" AI Agent)." \
      org.opencontainers.image.title="OpenClaw Gateway" \
      org.opencontainers.image.description="A lightweight Docker image for quick and easy deployment of OpenClaw (\"lobster\" AI Agent)." \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.source="https://github.com/lentiancn/dockerhub-gentkit-openclaw" \
      org.opencontainers.image.licenses="MIT"

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