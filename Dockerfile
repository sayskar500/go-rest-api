# Use a newer Go version (1.22) based on Alpine
FROM golang:1.22-alpine AS builder

# Set the working directory in the builder stage
WORKDIR /app

# Install required dependencies for CGO (e.g., build dependencies)
RUN apk add --no-cache build-base sqlite-dev

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application source code into the container
COPY . .

# Set CGO_ENABLED=1 to allow go-sqlite3 to use CGO
ENV CGO_ENABLED=1

# Build the Go binary
RUN go build -o main ./cmd/students-api/main.go

# Use a minimal image for running the app
FROM alpine:latest

# Set the working directory in the final image
WORKDIR /app

# Install dependencies required to run the Go binary (sqlite3 and bash)
RUN apk add --no-cache sqlite sqlite-libs bash

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Copy other necessary files (e.g., configuration, storage)
COPY config ./config
COPY storage ./storage

# Expose the application's port
EXPOSE 8082

# Command to run the Go app directly
CMD ["./main", "-config", "config/local.yaml"]