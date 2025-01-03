ARG GO_VERSION="1.22"
ARG GOLANGCI_LINT_VERSION="1.61"

# Build stage with Go
FROM golang:${GO_VERSION}-alpine AS build

WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o random

# Linter
FROM golangci/golangci-lint:v${GOLANGCI_LINT_VERSION}-alpine AS lint
RUN --mount=target=.,rw \
	golangci-lint run

# Test stage
FROM build AS test
RUN --mount=target=. \
	--mount=type=cache,target=/go/pkg/mod \
	go test .

# Release version with minmal file size
FROM gcr.io/distroless/static AS release

ARG GIN_MODE=release
ENV RV_DIR=/data/videos
ENV RV_PORT=3000

WORKDIR /app
COPY --from=build /go/src/app/random ./
COPY assets assets/
COPY templates templates/

VOLUME [ "/data" ]

EXPOSE ${PORT}
CMD ["./random"]
