ARG GO_VERSION="1.22"

# Build stage with Go
FROM golang:${GO_VERSION}-alpine AS build

WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o random

# Test stage
FROM build AS test
RUN --mount=target=. \
	--mount=type=cache,target=/go/pkg/mod \
	go test .

# Release version with minmal file size
FROM alpine:3.21.0 AS release

WORKDIR /app
COPY --from=build /go/src/app/random ./
COPY assets assets/
COPY templates templates/

EXPOSE 3000
CMD ["./random"]
