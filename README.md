# Docker NodeJs

![Docker Automated build](https://img.shields.io/docker/automated/asapdotid/node) ![Docker Pulls](https://img.shields.io/docker/pulls/asapdotid/node.svg)

## Additional services

-   Timezone support (default `Asia/Jakarta`)
-   GIT
-   Curl
-   Wget
-   Yarn [Document](https://yarnpkg.com/cli/install)
-   Node Prune [Document](https://gobinaries.com/tj/node-prune)
-   Canvas [Document](https://www.npmjs.com/package/canvas)
-   NuxtJS Production [nuxt-start](https://www.npmjs.com/package/nuxt-start)
-   PM2 [Document](https://pm2.keymetrics.io/docs/usage/docker-pm2-nodejs/)
-   Libcips-tools (Image processing system good for very large ones (tools)) - [Debian](https://packages.debian.org/buster/libvips-tools)
-   Vips (A fast image processing library with low memory needs.) - [Alpine Linux](https://pkgs.alpinelinux.org/package/edge/community/x86/vips)

### Versioning

| Docker Tag | Git Release | Node Version | OS Version    | Support                   | Functions                                   |
| ---------- | ----------- | ------------ | ------------- | ------------------------- | ------------------------------------------- |
| 14-buster  | Main Branch | 14.20.0      | Buster slim   | library Canvas            | Nuxt JS Build Process (GitLab CI/CD)        |
| 16-buster  | Main Branch | 16.17.0      | Buster slim   | library Canvas            | Nuxt JS Build Process (GitLab CI/CD)        |
| 14-alpine  | Main Branch | 14.21.2      | Alpine 3.17   | With images Library       | Nuxt JS Build Process (GitLab CI/CD)        |
| 16-alpine  | Main Branch | 16.19.0      | Alpine 3.17   | With images Library       | Nuxt JS Build Process (GitLab CI/CD)        |
| 14-debian  | Main Branch | 14.21.2      | Bullseye slim | library Canvas            | Nuxt JS Build Process (GitLab CI/CD)        |
| 16-debian  | Main Branch | 16.19.0      | Bullseye slim | library Canvas            | Nuxt JS Build Process (GitLab CI/CD)        |
| 14-nuxt    | Main Branch | 14.21.2      | Alpine 3.17   | PM2 + Nuxt Start (NuxtJS) | Nuxt JS Running Production (Docker Compose) |
| 16-nuxt    | Main Branch | 16.19.0      | Alpine 3.17   | PM2 + Nuxt Start (NuxtJS) | Nuxt JS Running Production (Docker Compose) |

## How To Use

### Package NuxtJS config

```json
{
  "name": "nuxt-app",
  "description": "Nuxtjs v2 application",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test": "jest",
    "postinstall": "yarn autoclean --force",
    "clean": "rimraf .nuxt && rimraf dist",
    "dev": "nuxt --dotenv .env.development",
    "build": "yarn clean && nuxt build --dotenv .env.development",
    "start": "nuxt start --dotenv .env.development",
    "generate": "nuxt generate --dotenv .env.development",
    "build:production": "yarn clean && NODE_OPTIONS=--max_old_space_size=512 nuxt build --dotenv .env.production",
    "start:production": "pm2 start pm2.json --only nuxt-app && pm2 logs",
    "reload:production": "pm2 reload pm2.json --only nuxt-app",
    "stop:production": "pm2 stop pm2.json --only nuxt-app",
    "delete:production": "yarn stop:production && pm2 delete pm2.json --only nuxt-app",
    "test:production": "nuxt start --dotenv .env.production"
  },
...
}
```

### Run Docker Compose

```yaml
---
version: "3.1"

networks:
    app-balancer:
        external: true

services:
    nuxt-app:
        container_name: nuxt-app
        image: asapdotid/node:14-alpine
        restart: unless-stopped
        tty: true
        environment:
            - "TZ=Asia/Jakarta"
        networks:
            - app-balancer
        expose:
            - "3000"
        volumes:
            - ./project-app:/app:rw
            - ./entrypoint.sh:/entrypoint.sh:ro
        command: sh -c "chmod -R 777 /entrypoint.sh && sh /entrypoint.sh"
```

Sample entrypoint for `NuxtJs version 2`(can edit with your application setup):

```bash
#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

print_line() {
    echo "-----------------------------------------------------------------------------"
}

setup_applications() {
  echo "Setting up the application"
  cd /app
  if [[ -d "./.nuxt" && -e "./nuxt.config.js" && -e "./.env" \
  && -e "./package.json" && -e "./pm2.json" ]]
  then
    echo "Project ready for starting, please wait a moment set back and relax!"
    if [ -e "./yarn.lock" ]; then
        /usr/local/bin/yarn start:production
    elif [ -e "./package.json" ]; then
        /usr/local/bin/npm run start:production
    fi
  else
    echo "Project ready for starting, please wait a moment to build and start!"
    if [ -e "./yarn.lock" ]; then
        /usr/local/bin/yarn install --pure-lockfile
        /usr/local/bin/yarn cache clean --force
        /usr/local/bin/yarn build:production
        /usr/local/bin/yarn start:production
    elif [ -e "./package.json" ]; then
        /usr/local/bin/npm install
        /usr/local/bin/npm cache clean --force
        /usr/local/bin/npm run build:production
        /usr/local/bin/npm run start:production
    fi
  fi
}

main() {
    print_line
    setup_applications
}

main $@
```

PM2 Config:

```json
{
    "apps": [
        {
            "name": "nuxt-app",
            "exec_mode": "cluster",
            "instances": 2,
            "script": "nuxt-start",
            "args": "--dotenv .env.production",
            "watch": true,
            "out_file": "/dev/null",
            "error_file": "/dev/null",
            "env": {
                "HOST": "0.0.0.0",
                "PORT": 3000,
                "NODE_ENV": "production"
            }
        }
    ]
}
```

### GitLab CI (`gitlab-ci.yml`)

Sample `gitlab-ci.yml` file for CI/CD **NuxtJS** App (`staging` branch):

```yaml
stages:
    - setup
    - build
    - deploy

variables:
    DOCKER_DRIVER: overlay2

# Caches
.node_modules-cache: &node_modules-cache
    key:
        files:
            - yarn.lock
    paths:
        - node_modules
    policy: pull

.yarn-cache: &yarn-cache
    key: yarn-$CI_JOB_IMAGE
    paths:
        - .yarn

.build-cache: &build-cache
    key: build-$CI_JOB_IMAGE
    paths:
        - .nuxt
        - .output
        - public
    policy: pull-push

# Staging - Jobs
setup:staging:
    stage: setup
    rules:
        - if: $CI_COMMIT_BRANCH == "staging"
          changes:
              - "package.json"
          when: always
    tags:
        - nuxt-staging-setup
    image: asapdotid/node:16-buster
    script:
        - yarn config set cache-folder .yarn
        - yarn install --frozen-lockfile --no-progress --cache-folder .yarn
    retry:
        max: 2
        when:
            - runner_system_failure
            - stuck_or_timeout_failure
    cache:
        - <<: *node_modules-cache
          policy: pull-push

build:staging:
    stage: build
    rules:
        - if: $CI_COMMIT_BRANCH == "staging"
    tags:
        - nuxt-staging-build
    image: asapdotid/node:16-buster
    before_script:
        - \cp ./.env.staging ./.env
    script:
        - yarn build:production
    artifacts:
        name: "$CI_COMMIT_BRANCH"
        paths:
            - .nuxt
            - .output
            - .env
            - ecosystem.config.js
            - nuxt.config.ts
            - package.json
            - yarn.lock
            - public
        expire_in: 1 hours
    retry:
        max: 2
        when:
            - runner_system_failure
            - stuck_or_timeout_failure
    cache:
        - <<: *node_modules-cache
        - <<: *build-cache
    dependencies:
        - setup:staging

deploy:staging:
    stage: deploy
    rules:
        - if: $CI_COMMIT_BRANCH == "staging"
    tags:
        - nuxt-staging-deploy
    image: asapdotid/ansible:tools
    variables:
        DEPLOY_SSH_HOST_SERVER: $STAGING_DEPLOY_SSH_HOST_IP
        DEPLOY_SSH_HOST_PRIVATE_KEY: $SSH_PRIVATE_KEY
        DEPLOY_SSH_HOST_PUBLIC_KEY: $SSH_PUBLIC_KEY
    script:
        - echo "Start deploy to the server"
        - |
            echo "Script to deploy build source.. (bash scriptor ansible script"
        - echo "Done deploy to the server"
    retry:
        max: 2
        when:
            - runner_system_failure
            - stuck_or_timeout_failure
    cache:
        - <<: *node_modules-cache
    dependencies:
        - build:staging
```

## Author Information

[JogjaScript](https://jogjascript.com)

This role was created in 2021 by [Asapdotid](https://github.com/asapdotid).
