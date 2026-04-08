# OpenClaw under Docker

## Introduction

A lightweight Docker image for quick and easy deployment of OpenClaw ("lobster" AI Agent Gateway).

## Install Docker environment

[Installation-Guide](https://github.com/lentiancn/open-docs/blob/main/en/Docker/2.Installation-Guide.md)

## Install Container with OpenClaw

step 1 :

```shell
sudo mkdir -p /usr/local/openclaw

sudo chown -R 6001:6001 /usr/local/openclaw
```

step 2 :

```shell
sudo docker run -d \
-p 18789:18789 \
-v /usr/local/openclaw:/home/openclaw/.openclaw:rw \
-e GATEWAY_TOKEN=<your token> \
--restart unless-stopped \
--name OpenClaw \
gentkit/openclaw:latest
```

**NOTE** : It's recommended to set up **/home/openclaw/.openclaw** as a volume to ensure that your OpenClaw data can be backed up on the host machine.

**GATEWAY_TOKEN** can be set to any value you prefer (obtainable via **openssl rand -hex 32**). If not provided, the system will retrieve it via **openssl rand -hex 32** by default.

## Manage OpenClaw

### OpenClaw Home

```shell
ls -l ~/.openclaw
```

### Modify OpenClaw configuration

```shell
# enter Docker container
docker exec -it <your container id or name> /bin/bash

# view or edit
vi ~/.openclaw/openclaw.json
```

### OpenClaw gateway status

```shell
# start OpenClaw gateway
docker start <your container id or name>

# stop OpenClaw gateway
docker stop <your container id or name>
```

## Appendix

[FAQ](FAQ.md)

