# build stage
FROM node:lts-alpine AS build-stage
# Set environment variables for non-interactive npm installs
ENV NPM_CONFIG_LOGLEVEL warn
ENV CI true
WORKDIR /app
# COPY package.json pnpm-lock.yaml ./
COPY package.json package-lock.json ./
# RUN npm install -g pnpm && pnpm i --frozen-lockfile
RUN npm ci
COPY . .
# RUN pnpm build
RUN npm run build

# production stage
FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
