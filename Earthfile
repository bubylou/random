VERSION 0.8
FROM cgr.dev/chainguard/go
LABEL org.opencontainers.image.source="https://github.com/bubylou/random"
LABEL org.opencontainers.image.authors="Nicholas Malcolm <bubylou@pm.me>"
LABEL org.opencontainers.image.licenses="GPL3+"
WORKDIR /go/src/app

deps:
    COPY go.mod go.sum ./
    RUN go mod download

    # Output these back in case go mod download changes them.
    SAVE ARTIFACT go.mod AS LOCAL go.mod
    SAVE ARTIFACT go.sum AS LOCAL go.sum

build:
    FROM +deps
    ARG CGO_ENABLED=0

    COPY main.go .
    RUN go build -o output/random main.go

    SAVE ARTIFACT output/random

container:
    FROM cgr.dev/chainguard/static
    ARG --required tag

    ENV GIN_MODE=release
    ENV RV_DIR=/data/videos
    ENV RV_PORT=3000

    COPY +build/random .
    COPY assets assets/
    COPY templates templates/
    ENTRYPOINT ["./random"]

    # --push still required from cli to send to registry
    SAVE IMAGE --push docker.io/bubylou/random:$tag docker.io/bubylou/random:latest
    SAVE IMAGE --push ghcr.io/bubylou/random:$tag ghcr.io/bubylou/random:latest

test:
    FROM +deps
    COPY *.go .
    ENTRYPOINT ["go", "test"]

all:
    BUILD +build
    BUILD +test
    BUILD +container

release:
    BUILD --platform=linux/amd64 --platform=linux/arm64 +all
