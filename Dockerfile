FROM node:14-alpine

# Metadata params
ARG BUILD_DATE
ARG VCS_REF

# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>" \
      org.label-schema.url="https://gitlab.com/asap-labs/docker-node-alpine/-/blob/main/README.md" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.version=lts-alpine \
      org.label-schema.vcs-url="https://gitlab.com/asap-labs/docker-node-alpine.git" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.description="NodeJS on alpine docker image" \
      org.label-schema.schema-version="1.0"

RUN apk --no-cache add git make automake g++ curl autoconf libtool libpng-dev nasm

RUN curl -sf https://gobinaries.com/tj/node-prune | sh

RUN rm -rf /tmp/*

# default command
CMD [ "node" ]
