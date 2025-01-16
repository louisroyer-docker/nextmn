# NextMN Docker Images
> [!WARNING]
> **The following images are NOT official builds of NextMN**, in the future they may include beta-functionalities.

> [!TIP]
> By default, configuration file from templating is used if no `--config` or `-c` is passed as argument. To start without argument, use:
> ```yaml
> command: [" "]
> ```

## Configuration
### NextMN-UPF
- On Dockerhub: [`louisroyer/dev-nextmn-upf`](https://hub.docker.com/r/louisroyer/dev-nextmn-upf).

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/upf` is provided to you under MIT License.
> A copy of the source code is available at in the repository [`nextmn/upf`](https://github.com/nextmn/upf).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/nextmn/upf.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/nextmn/template-upf.yaml"
```

Environment variables for templating:
```yaml
environment:
  N4: "203.0.113.2"
  DNN_LIST: |-
    - dnn: "sliceA"
      cidr: "10.0.111.0./24"
  GTPU_ENTITIES_LIST: |-
    - "10.0.201.5"
    - "10.0.215.4"
  LOG_LEVEL: "info"
```

#### Routing
> [!TIP]
> If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".

#### Container deployment
> [!IMPORTANT]
> - The container requires the `NET_ADMIN` capability;
> - The container requires the forwarding to be enabled (not enabled by the container itself);
> - The tun interface (`/dev/net/tun`) must be available in the container.

This can be done in `docker-compose.yaml` by defining the following for the service:

```yaml
cap_add:
    - NET_ADMIN
devices:
    - "/dev/net/tun"
sysctls:
    - net.ipv4.ip_forward=1
```

### NextMN-SRv6-ctrl
- On Dockerhub: [`louisroyer/dev-nextmn-srv6-ctrl`](https://hub.docker.com/r/louisroyer/dev-nextmn-srv6-ctrl).

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/srv6-ctrl` is provided to you under MIT License.
> A copy of the source code is available at in the repository [`nextmn/srv6-ctrl`](https://github.com/nextmn/srv6-ctrl).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/nextmn/srv6-ctrl.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/nextmn/template-srv6-ctrl.yaml"
```

Environment variables for templating:
```yaml
environment:
  N4: "203.0.113.2"
  HTTP_ADDRESS: "192.0.2.2"
  HTTP_PORT: "8080"
  LOG_LEVEL: "info"
```

#### Routing
> [!TIP]
> If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".
> By default, it does nothing, but if you intend to use it, don't forget to add the capability `NET_ADMIN`.


### NextMN-SRv6
- On Dockerhub: [`louisroyer/dev-nextmn-srv6`](https://hub.docker.com/r/louisroyer/dev-nextmn-srv6).

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/srv6` is provided to you under MIT License.
> A copy of the source code is available at in the repository [`nextmn/srv6`](https://github.com/nextmn/srv6).


Environment variable used to select templating system:
```yaml
environment:
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/nextmn/srv6.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/nextmn/template-srv6.yaml"
```

Environment variables for templating:
```yaml
environment:
  CONTROLLER_URI: "http://192.0.2.2:8080"
  HTTP_ADDRESS: "192.0.2.1"
  HTTP_PORT: "8080"
  BACKBONE_IP: "fd00::1"
  HOOKS: |-
    pre-init-hook: pre-init-hook.sh
    post-init-hook: post-init-hook.sh
    pre-exit-hook: pre-exit-hook.sh
    post-exit-hook: post-exit-hook.sh
  LOCATOR: "fd00:51D5:0000:1::/64"
  HEADENDS: |-
    - name: "gtp4 to sr"
      to: "10.0.200.3/32"
      provider: "NextMN"
      behavior: "H.M.GTP4.D"
      policy:
        - match:
            teid: 0x0001
          bsid:
            bsid-prefix: "fd00:51D5:000:2::/80"
            segments-list:
              - "fd00:51D5:0000:3::"
              - "fd00:51D5:0000:4::"
      source-address-prefix: "fd00:51D5:000:1:9999::/80"
    - name: "linux test"
      to: "10.0.100.0/24"
      provider: "Linux"
      behavior: "H.Encaps"
      policy:
        - bsid:
            segments-list:
              - "fd00:51D5:0000:2::"
              - "fd00:51D5:0000:3::"
  ENDPOINTS: |-
    - prefix: "fd00:51D5:0000:1:11::/80"
      behavior: "End.DX4"
      provider: "Linux"
    - prefix: "fd00:51D5:0000:1:1::/80"
      behavior: "End"
      provider: "Linux"
  LINUX_HEADEND_SET_SOURCE_ADDRESS: fd00:51D5:0000::
  GTP4_HEADEND_PREFIX: 10.0.200.3/32
  LOG_LEVEL: "info"
```

#### Container deployment
> [!IMPORTANT]
> - The container requires the `NET_ADMIN` capability;
> - The container should enable IPv6, and Segment Routing
> - The container requires the forwarding to be enabled (not enabled by the container itself);
> - The tun interface (`/dev/net/tun`) must be available in the container.

This can be done in `docker-compose.yaml` by defining the following for the service:

```yaml
cap_add:
    - NET_ADMIN
devices:
    - "/dev/net/tun"
sysctls:
    - net.ipv6.conf.all.disable_ipv6=0
    - net.ipv4.ip_forward=1
    - net.ipv6.conf.all.forwarding=1
    - net.ipv6.conf.all.seg6_enabled=1
    - net.ipv6.conf.default.seg6_enabled=1
```

### NextMN UE-Lite
- On Dockerhub: [`louisroyer/dev-nextmn-ue-lite`](https://hub.docker.com/r/louisroyer/dev-nextmn-ue-lite).

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/ue-lite` is provided to you under MIT License.
> A copy of the source code is available at in the repository [`nextmn/ue-lite`](https://github.com/nextmn/ue-lite).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/nextmn/ue-lite.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/nextmn/template-ue-lite.yaml"
```

Environment variables for templating:
```yaml
environment:
  HTTP_ADDRESS: "192.0.2.3"
  HTTP_PORT: "8080"
  RAN: |-
    bind-addr: "10.1.0.2:1234"
    gnbs:
      - "http://192.0.2.4:8080"
    pdu-sessions:
      - gnb: "http://192.0.2.4:8080"
        dnn: "nextmn-lite"
  LOG_LEVEL: "info"
```


#### Routing
> [!TIP]
> If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".

#### Container deployment
> [!IMPORTANT]
> - The container requires the `NET_ADMIN` capability;
> - The tun interface (`/dev/net/tun`) must be available in the container.

This can be done in `docker-compose.yaml` by defining the following for the service:

```yaml
cap_add:
    - NET_ADMIN
devices:
    - "/dev/net/tun"
```
### NextMN gNB-Lite
- On Dockerhub: [`louisroyer/dev-nextmn-gnb-lite`](https://hub.docker.com/r/louisroyer/dev-nextmn-gnb-lite).

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/gnb-lite` is provided to you under MIT License.
> A copy of the source code is available at in the repository [`nextmn/gnb-lite`](https://github.com/nextmn/gnb-lite).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/nextmn/gnb-lite.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/nextmn/template-gnb-lite.yaml"
```

Environment variables for templating:
```yaml
environment:
  HTTP_ADDRESS: "192.0.2.4"
  HTTP_PORT: "8080"
  CP: "http://192.0.2.5:8080"
  N3: "10.0.200.4"
  RAN: |-
    bind-addr: "10.1.0.1:1234"
  LOG_LEVEL: "info"
```

#### Routing
> [!TIP]
> If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".

#### Container deployment
> [!IMPORTANT]
> - The container requires the `NET_ADMIN` capability (if you want to configure the container using `docker-setup`).

This can be done in `docker-compose.yaml` by defining the following for the service:

```yaml
cap_add:
    - NET_ADMIN
```

### NextMN CP-Lite
- On Dockerhub: [`louisroyer/dev-nextmn-cp-lite`](https://hub.docker.com/r/louisroyer/dev-nextmn-cp-lite).

> [!NOTE]
> Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/cp-lite` is provided to you under MIT License.
> A copy of the source code is available at in the repository [`nextmn/cp-lite`](https://github.com/nextmn/cp-lite).

Environment variable used to select templating system:
```yaml
environment:
  ROUTING_SCRIPT: "docker-setup"
  TEMPLATE_SCRIPT: "template-script.sh"
  TEMPLATE_SCRIPT_ARGS: ""
  CONFIG_FILE: "/etc/nextmn/cp-lite.yaml"
  CONFIG_TEMPLATE: "/usr/local/share/nextmn/template-cp-lite.yaml"
```

Environment variables for templating:
```yaml
environment:
  N4: "203.0.113.3"
  HTTP_ADDRESS: "192.0.2.5"
  HTTP_PORT: "8080"
  SLICES: |-
    nextmn-lite:
      pool: "10.0.111.0/24"
      upfs:
        - node-id: "203.0.113.2"
          interfaces:
            - type: "N3"
              addr: "10.0.200.3"
  AREAS: |-
    gnbs:
      - "http://192.0.2.4:8080"
    paths:
      nextmn-lite:
        - "203.0.113.2"
  LOG_LEVEL: "info"
```

#### Routing
> [!TIP]
> If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".

#### Container deployment
> [!IMPORTANT]
> - The container requires the `NET_ADMIN` capability (if you want to configure the container using `docker-setup`).

This can be done in `docker-compose.yaml` by defining the following for the service:

```yaml
cap_add:
    - NET_ADMIN
```
