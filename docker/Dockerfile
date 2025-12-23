FROM node:22.18.0-alpine3.20 AS base
RUN apk update --no-cache && apk add --no-cache \
    tzdata \
    make \
    g++ \
    pixman-dev \
    cairo-dev \
    pango-dev \
    pkgconfig \
    curl

# Install pnpm using npm (more reliable than corepack in Docker)
RUN npm install -g pnpm@latest

COPY . /app
WORKDIR /app

FROM base AS builder
ENV NODE_OPTIONS="--max-old-space-size=8192"

# Install dependencies using pnpm
RUN pnpm install --frozen-lockfile

# Build the web app
RUN pnpm --filter @md/web run build:h5-netlify:only

# Final stage: lightweight Node.js server
FROM node:22.18.0-alpine3.20 AS final
ENV TZ=Asia/Shanghai

# Install serve for static file hosting
RUN npm install -g serve

# Copy build artifacts
COPY --from=builder /app/apps/web/dist /app/dist

WORKDIR /app

EXPOSE 3000

# Use serve to host static files
CMD ["serve", "-s", "dist", "-l", "3000"]
