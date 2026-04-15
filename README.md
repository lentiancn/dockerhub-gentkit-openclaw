# OpenClaw on Docker

[![MIT License](https://img.shields.io/github/license/lentiancn/docker-gentkit-openclaw.svg?style=flat-square&label=license)](LICENSE)
[![GitHub Release](https://img.shields.io/github/tag/lentiancn/docker-gentkit-openclaw.svg?style=flat-square&sort=date&label=release)](https://github.com/lentiancn/docker-gentkit-openclaw/releases)

A lightweight Docker image for quick and easy deployment of OpenClaw ("lobster🦞" AI Agent).

## Install Docker environment

[Installation-Guide](https://github.com/lentiancn/open-docs/blob/main/en/Docker/2.Installation-Guide.md)

## Install OpenClaw

step 1 : Create home directory and set permission

```shell
sudo mkdir -p /usr/local/openclaw

# 6001 is the uid and gid of the user running the Docker container
sudo chown -R 6001:6001 /usr/local/openclaw
```

step 2 : Generate and remember your token

```shell
# 
# Replace <your_token> in [step 3] and use it for first-time setup at http://localhost:18789
# Must match exactly
## e.g. CentOS / RHEL / Fedora
sudo yum install openssl -y && openssl rand -hex 32
## e.g. Debian / Ubuntu
sudo apt install openssl -y && openssl rand -hex 32
```

step 3 : Pull and run a new container

```shell
sudo docker run -d \
-p 18789:18789 \
-v /usr/local/openclaw:/home/openclaw/.openclaw:rw \
-e GATEWAY_TOKEN=<your_token> \
--restart unless-stopped \
--name OpenClaw \
gentkit/openclaw:latest
```

**NOTE** : It's recommended to set up **/home/openclaw/.openclaw** as a volume to ensure that your OpenClaw data can be
backed up on the host machine.

**GATEWAY_TOKEN** can be set to any value you prefer (obtainable via **openssl rand -hex 32**). If not provided, the
system will retrieve it via **openssl rand -hex 32** by default.

## Manage OpenClaw

### OpenClaw Home

```shell
ls -l ~/.openclaw
```

### Modify OpenClaw configuration

```shell
# enter Docker container
docker exec -it <your_container_id or your_container_name> /bin/bash

# view or edit
vi ~/.openclaw/openclaw.json
```

### OpenClaw gateway status

```shell
# start OpenClaw gateway
docker start <your_container_id or your_container_name>

# stop OpenClaw gateway
docker stop <your_container_id or your_container_name>
```

### Visit OpenClaw gateway UI

    http://localhost:18789

## Appendix

[FAQ](FAQ.md)
