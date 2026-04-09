# FAQ

## origin not allowed (open the Control UI from the gateway host or allow it in gateway.controlUi.allowedOrigins)

### Your host is neither localhost nor 127.0.0.1 (i.e. http://&lt;Host&gt;:&lt;Port&gt;)

#### Solution

Method 1. Use localhost or 127.0.0.1 as the Host for access. (Recommended, more secure as it allows local access only)

Method 2. Expect to use the host machine's hostname or the host machine's IP address as the Host.

1) Enter the container : docker exec -it <container_name> /bin/bash

2) Add configuration : vi ~/.openclaw/openclaw.json, Add an entry in the format <Host>:<Port> under the
   gateway.controlUi.allowedOrigins node.

3) Restart the service : openclaw gateway restart

### Your host port is not 18789 (i.e., docker run -p <host_port>:18789 ...)

#### Solution

Recreate the container and set the host port to 18789. (NOTE: Back up the data and operation commands of the Docker
container)

## unauthorized: gateway token missing (open the dashboard URL and paste the token in Control UI settings)

#### Solution

1) Generate a token using: openssl rand -hex 32.

2) Set it as the GATEWAY_TOKEN environment variable.

3) After restarting the gateway, configure the gateway token to match the value of GATEWAY_TOKEN.

## pairing required

TODO
