# Docker NodeJs base image (Node Prune)

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/node-alpine) [![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/node-alpine.svg)](https://hub.docker.com/r/asapdotid/node-alpine/)

## Additional services

-   Node Prune (https://gobinaries.com/tj/node-prune)

## Usage

### Run Playbook

```
docker run -it --rm \
  -v ${PWD}:/node \
  asapdotid/node-alpine:latest \
  node-playbook -i inventory playbook.yml
```
