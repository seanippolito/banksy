# -------------------------------
# Stage 1: Builder (for prod)
# -------------------------------
FROM node:20-alpine AS builder
WORKDIR /app

# Copy workspace metadata and lockfile
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml* ./
COPY apps/frontend ./apps/frontend
COPY packages ./packages

# Install pnpm and dependencies
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

# Build frontend
RUN pnpm --filter frontend build

# -------------------------------
# Stage 2: Production runner
# -------------------------------
FROM node:20-alpine AS runner
WORKDIR /app

# Copy built app and dependencies
COPY --from=builder /app/apps/frontend/.next ./.next
COPY --from=builder /app/apps/frontend/public ./public
COPY --from=builder /app/apps/frontend/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]

# -------------------------------
# Stage 3: Development (Turbopack)
# -------------------------------
FROM node:20-alpine AS dev
WORKDIR /app

# Copy metadata and source
COPY pnpm-workspace.yaml package.json pnpm-lock.yaml* ./
COPY apps/frontend ./apps/frontend
COPY packages ./packages

# Install pnpm and dependencies inside container
RUN npm install -g pnpm
RUN pnpm install

EXPOSE 3000

# Start Next.js dev server with Turbopack
CMD ["pnpm", "--filter", "frontend", "dev", "--turbo"]
