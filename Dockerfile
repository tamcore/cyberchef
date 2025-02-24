FROM --platform=$BUILDPLATFORM node:16.20.2 as build

# renovate: datasource=github-releases depName=gchq/CyberChef
ARG CYBERCHEF_VERSION="v10.19.4"

ARG BUILD_TYPE="release" # or use git for build from source

USER node

WORKDIR /app

RUN \
    set -xe; \
    if [ "x${BUILD_TYPE}" = "xgit" ]; then \
        git clone -b "$CYBERCHEF_VERSION" --depth=1 https://github.com/gchq/CyberChef.git .; \
        npm install; \
        NODE_OPTIONS="--max-old-space-size=2048" npx grunt prod; \
    else \
        curl -L -o cyberchef.zip \
            https://github.com/gchq/CyberChef/releases/download/${CYBERCHEF_VERSION}/CyberChef_${CYBERCHEF_VERSION}.zip; \
        mkdir build; \
        unzip cyberchef.zip -d build/prod; \
        mv -fv build/prod/CyberChef_${CYBERCHEF_VERSION}.html build/prod/index.html; \
    fi

FROM nginxinc/nginx-unprivileged:1.27.4-alpine-slim

COPY --from=build --chown=0:0 /app/build/prod /usr/share/nginx/html

EXPOSE 8080
