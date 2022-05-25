FROM node:17.9.0-alpine3.14 as build

# renovate: datasource=github-releases depName=gchq/CyberChef
ARG CYBERCHEF_VERSION="v9.37.3"

RUN chown -R node:node /srv

RUN apk add git

USER node

WORKDIR /srv

RUN git clone -b "$CYBERCHEF_VERSION" --depth=1 https://github.com/gchq/CyberChef.git .

RUN npm install

ENV NODE_OPTIONS="--max-old-space-size=2048"

RUN npx grunt prod

FROM nginxinc/nginx-unprivileged:1.22-alpine

COPY --from=build /srv/build/prod /usr/share/nginx/html

EXPOSE 8080
