# ---- Stage 1: Builder ----
FROM node:18-alpine AS builder
WORKDIR /app

# Install deps
COPY package*.json ./
RUN npm ci --prefer-offline

# Copy all source
COPY . .

# Build Next.js
RUN npm run build

# ---- Stage 2: Runtime ----
FROM node:18-alpine
WORKDIR /app

# Only copy needed files
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./

# Install only production deps
RUN npm ci --omit=dev --prefer-offline

EXPOSE 3000
CMD ["npm", "start"]
