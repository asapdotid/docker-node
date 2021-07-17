FROM alpine:3.14

# Metadata params
ARG BUILD_DATE
ARG VCS_REF
ARG NODE_VERSION
ARG NPM_VERSION
ARG YARN_VERSION
ARG PM2_VERSION
ARG NODE_BUILD_PYTHON


# Metadata
LABEL maintainer="Asapdotid <asapdotid@gmail.com>" \
      org.label-schema.url="https://gitlab.com/asap-labs/docker-ansible-alpine/-/blob/main/README.md" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.version=${NODE_VERSION} \
      org.label-schema.vcs-url="https://gitlab.com/asap-labs/docker-ansible-alpine.git" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.description="NodeJS on alpine docker image" \
      org.label-schema.schema-version="1.0"

RUN apk upgrade --no-cache -U && \
  apk add --no-cache curl make gcc g++ ${NODE_BUILD_PYTHON} linux-headers binutils-gold gnupg libstdc++

RUN for server in hkps://keys.openpgp.org ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net; do \
    gpg --keyserver $server --recv-keys \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C && break; \
  done

RUN curl -sfSLO https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.xz && \
  curl -sfSL https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc | gpg -d -o SHASUMS256.txt && \
  grep " node-${NODE_VERSION}.tar.xz\$" SHASUMS256.txt | sha256sum -c | grep ': OK$' && \
  tar -xf node-${NODE_VERSION}.tar.xz && \
  cd node-${NODE_VERSION} && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  make -j$(getconf _NPROCESSORS_ONLN) && \
  make install

RUN if [ -z "$CONFIG_FLAGS" ]; then \
       if [ -n "$NPM_VERSION" ]; then \
              npm install -g npm@${NPM_VERSION}; \
       fi; \
       find /usr/lib/node_modules/npm -type d \( -name test -o -name .bin \) | xargs rm -rf; \
       if [ -n "$YARN_VERSION" ]; then \
              for server in hkps://keys.openpgp.org ipv4.pool.sks-keyservers.net keyserver.pgp.com ha.pool.sks-keyservers.net; do \
                     gpg --keyserver $server --recv-keys \
                     6A010C5166006599AA17F08146C2130DFD2497F5 && break; \
              done && \
              curl -sfSL -O https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz -O https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz.asc && \
              gpg --batch --verify yarn-${YARN_VERSION}.tar.gz.asc yarn-${YARN_VERSION}.tar.gz && \
              mkdir /usr/local/share/yarn && \
              tar -xf yarn-${YARN_VERSION}.tar.gz -C /usr/local/share/yarn --strip 1 && \
              ln -s /usr/local/share/yarn/bin/yarn /usr/local/bin/ && \
              ln -s /usr/local/share/yarn/bin/yarnpkg /usr/local/bin/ && \
              rm yarn-${YARN_VERSION}.tar.gz*; \
       fi; \
   fi

RUN if [ -n "$NPM_VERSION" ]; then \
      npm install -g pm2@${PM2_VERSION}; \
    fi

RUN apk del curl make gcc g++ ${NODE_BUILD_PYTHON} linux-headers binutils-gold gnupg ${DEL_PKGS} && \
  rm -rf ${RM_DIRS} /node-${NODE_VERSION}* /SHASUMS256.txt /tmp/* \
    /usr/share/man/* /usr/share/doc /root/.npm /root/.node-gyp /root/.config \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/docs \
    /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts && \
  { rm -rf /root/.gnupg || true; }

ENTRYPOINT ["entrypoint"]

# default command: display Ansible version
CMD [ "node", "--version" ]
