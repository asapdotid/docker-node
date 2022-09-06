# Docker NodeJs

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/node) ![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/node.svg)
<<<<<<< HEAD

-   (asapdotid/node:14-alpine) NodeJS 14 Alpine ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/node/14-alpine)
-   (asapdotid/node:14-buster) NodeJS 14 Buster (support canvas) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/node/14-buster)

## Additional services

-   Node Prune [Document](https://gobinaries.com/tj/node-prune)
-   Canvas [Document](https://www.npmjs.com/package/canvas)
=======

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
>>>>>>> develop

## Usage

### Run Playbook

```
docker run -it --rm \
  -v ${PWD}:/node \
  asapdotid/node:14-alpine \
  node-playbook -i inventory playbook.yml
```

<<<<<<< HEAD
---

Do not hesitate if there are suggestions and criticisms 😃 :) [@asapdotid](https://github.com/asapdotid)
=======
## Author Information

[JogjaScript](https://jogjascript.com)

This role was created in 2021 by [Asapdotid](https://github.com/asapdotid).
>>>>>>> develop
