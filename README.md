# NextMN Docker Images
WARNING: **The following images are NOT official builds of NextMN**, in the future they may include beta-functionalities.

By default, configuration file from templating is used if no `--config` or `-c` is passed as argument. To start without argument, use:

```yaml
command: [" "]
```

## Configuration
### NextMN-SRv6-ctrl
- On Dockerhub: [`louisroyer/dev-free5gc-amf`](https://hub.docker.com/r/louisroyer/dev-nextmn-srv6-ctrl).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/srv6-ctrl` is provided to you under MIT License.
A copy of the source code is available at in the repository [`nextmn/srv6-ctrl`](https://github.com/nextmn/srv6-ctrl).

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
```

#### Routing
If you choose to configure the container using `docker-setup` (default), please refer to [`docker-setup`'s documentation](https://github.com/louisroyer/docker-setup). The environment variable ONESHOT is set to "true".
By default, it does nothing, but if you intend to use it, don't forget to add the capability `NET_ADMIN`.


### NextMN-SRv6
- On Dockerhub: [`louisroyer/dev-nextmn-srv6`](https://hub.docker.com/r/louisroyer/dev-nextmn-srv6).

Please note that even if this software is not yet properly packaged using `.deb`, the generated binary file `/usr/local/bin/srv6` is provided to you under MIT License.
A copy of the source code is available at in the repository [`nextmn/srv6`](https://github.com/nextmn/srv6).


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
  N4: "203.0.113.2"
```

#### Container deployment
- The container requires the `NET_ADMIN` capability;
- The container should enable IPv6, and Segment Routing
- The container requires the forwarding to be enabled (not enabled by the container itself);
- The tun interface (`/dev/net/tun`) must be available in the container.

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
