#
# MIT License
#
# https://github.com/lentiancn/dockerhub-gentkit-openclaw/blob/main/LICENSE
#
FROM node:25.9.0-alpine3.23

LABEL maintainer="gentkit@126.com"
LABEL description="OpenClaw Container"
LABEL version="1.0.0"

ENV GATEWAY_PORT=18789

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

COPY entrypoint.sh /usr/local/docker/entrypoint.sh

RUN set -x && chmod +x /usr/local/docker/entrypoint.sh

EXPOSE $GATEWAY_PORT

USER openclaw

WORKDIR /home/openclaw

ENTRYPOINT ["/bin/bash", "-c", "/usr/local/docker/entrypoint.sh"]