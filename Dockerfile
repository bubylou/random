# Build the application from source
FROM golang:1.22-alpine AS build-stage

WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o random

# Release version with minmal file size
FROM alpine:3.21.0 AS release-stage
WORKDIR /app
COPY --from=build-stage /go/src/app/random ./
COPY assets assets/
COPY templates templates/

EXPOSE 3000
CMD ["./random"]
