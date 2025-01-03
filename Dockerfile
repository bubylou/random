ARG GO_VERSION="1.22"

# Build stage with Go
FROM golang:${GO_VERSION} AS build

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
FROM gcr.io/distroless/static:nonroot AS release

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
