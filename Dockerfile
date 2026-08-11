FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM caddy:2-alpine
RUN apk add --no-cache libcap && setcap -r /usr/bin/caddy   # ← strip the file capability
COPY --from=build /app/dist /srv
COPY Caddyfile /etc/caddy/Caddyfile
