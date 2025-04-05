# Use Go 1.23 bookworm as base image
FROM golang:1.23-bookworm AS base

# Development stage
# =============================================================================
FROM base AS development

WORKDIR /app

# Install the air CLI for auto-reloading
RUN go install github.com/air-verse/air@latest

COPY go.mod go.sum ./
RUN go mod download

CMD ["air"]

# Builder stage
# =============================================================================
FROM base AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build the application
RUN CGO_ENABLED=0 go build -o go-blog

# Production stage
# =============================================================================
FROM golang:1.23-alpine AS production

WORKDIR /prod

# Copy the application binary from the builder stage
COPY --from=builder /build/go-blog ./

# Install the golang-migrate CLI for database migrations
RUN go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

# Copy the migration files
COPY --from=builder /build/repository/migrations ./migrations

# Copy the entrypoint script
COPY --from=builder /build/entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

# Expose the application port
EXPOSE 8000

# Set the entrypoint
ENTRYPOINT ["./entrypoint.sh"]

# Start the application
CMD ["./go-blog"]
