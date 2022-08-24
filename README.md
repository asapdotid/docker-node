# Docker NodeJs base image (Node Prune)

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/node) ![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/node.svg)

## Additional services

-   Timezone support (default `Asia/Jakarta`)
-   Node Prune [Document](https://gobinaries.com/tj/node-prune)
-   Canvas [Document](https://www.npmjs.com/package/canvas)
-   NuxtJS production [nuxt-start](https://www.npmjs.com/package/nuxt-start)

### Versioning

| Docker Tag | Git Release | Node Version | OS Version  | Support             |
| ---------- | ----------- | ------------ | ----------- | ------------------- |
| 14-alpine  | Main Branch | 14.20.0      | Alpine 3.15 | Node Image          |
| 16-alpine  | Main Branch | 16.17.0      | Alpine 3.15 | Node Image          |
| 14-buster  | Main Branch | 14.20.0      | Buster slim | library Canvas      |
| 16-buster  | Main Branch | 16.17.0      | Buster slim | library Canvas      |
| 14-nuxt    | Main Branch | 14.20.0      | Alpine 3.15 | Nuxt Start (NuxtJS) |
| 16-nuxt    | Main Branch | 16.17.0      | Alpine 3.15 | Nuxt Start (NuxtJS) |

## Usage

### Run Playbook

```
docker run -it --rm \
  -v ${PWD}:/node \
  asapdotid/node-alpine:latest \
  node-playbook -i inventory playbook.yml
```

## Author Information

[JogjaScript](https://jogjascript.com)

This role was created in 2021 by [Asapdotid](https://github.com/asapdotid).
