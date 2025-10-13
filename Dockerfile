# Multi-stage Dockerfile: build Flutter web app, then serve with Nginx

# --- Build stage ---
FROM ghcr.io/cirruslabs/flutter:3.35.6 AS build

WORKDIR /app

# Prime Flutter and fetch dependencies first for better layer caching
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the source code
COPY . .

# Ensure web is enabled and build release; skip wasm dry run
RUN flutter config --enable-web \
 && flutter build web --release --no-wasm-dry-run

# --- Runtime stage ---
FROM nginx:1.25-alpine AS runtime

# Copy custom nginx config and built app
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose Nginx on 8080 (see nginx.conf)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]


