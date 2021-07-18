FROM node:lts-alpine

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

RUN npm install pm2 -g

# default command: display PM2 version
CMD [ "pm2-runtime", "--version" ]
