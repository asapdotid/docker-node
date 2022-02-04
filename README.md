# Docker NodeJs

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/node) ![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/node.svg)

-   (asapdotid/node:14-alpine) NodeJS 14 Alpine ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/node/14-alpine)
-   (asapdotid/node:14-buster) NodeJS 14 Buster (support canvas) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/asapdotid/node/14-buster)

## Additional services

-   Node Prune [Document](https://gobinaries.com/tj/node-prune)
-   Canvas [Document](https://www.npmjs.com/package/canvas)

## Usage

### Run Playbook

```
docker run -it --rm \
  -v ${PWD}:/node \
  asapdotid/node:14-alpine \
  node-playbook -i inventory playbook.yml
```

---

Do not hesitate if there are suggestions and criticisms 😃 :) [@asapdotid](https://github.com/asapdotid)
