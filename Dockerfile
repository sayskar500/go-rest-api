# Use a lightweight Golang image
FROM golang:1.20-alpine as builder

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go binary
RUN go build -o main ./cmd/students-api/main.go

# Use a minimal image for running the app
FROM alpine:latest

# Set the working directory
WORKDIR /app

# Copy the built binary from the builder
COPY --from=builder /app/main .

# Copy other necessary files (e.g., configuration and database)
COPY config ./config
COPY storage/storage.db ./storage/storage.db

# Expose the application's port
EXPOSE 8080

# Command to run the app
CMD ["./main"]