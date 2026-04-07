# FAQ

## origin not allowed (open the Control UI from the gateway host or allow it in gateway.controlUi.allowedOrigins)

### 你的 Host 不是 localhost，也不是 127.0.0.1 ？ (即 http://&lt;Host&gt;:&lt;Port&gt;)

解决方法：

1）改成使用 localhost 或 127.0.0.1 作为 Host 进行访问。 (推荐，只能本地访问更安全)

2）期望使用宿主机的 hostname 或宿主机的IP 作为 Host。
     
    进入到容器： docker exec -it <容器名称> /bin/bash

    增加配置： vi ~/.openclaw/openclaw.json ，在 gateway/controlUi/allowedOrigins 节点下增加 <Host>:<Port> 结构的配置

    重启服务： openclaw gateway restart

### 你的宿主机端口不是 18789 (即 docker run -v &lt;宿主机端口&gt;:18789 ...)

解决方法：

重新创建容器，把 “宿主机端口” 设置成 18789。（注意备份docker容器的数据和操作指令）

## unauthorized: gateway token missing (open the dashboard URL and paste the token in Control UI settings)

解决方法：

openssl rand -hex 32，生成的内容传递给 GATEWAY_TOKEN 环境变量，重启gateway后，网关令牌设置成与 GATEWAY_TOKEN 值一样的内容。

