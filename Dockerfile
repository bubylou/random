# Build the application from source
FROM golang:alpine AS build-stage

WORKDIR /go/src/app
COPY go.mod ./
RUN go mod download

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o random

# Release version with minmal file size
FROM alpine:3.18 AS release-stage
WORKDIR /app
COPY --from=build-stage /go/src/app/random ./
COPY index.html .
COPY assets assets/
RUN mkdir /video

EXPOSE 3000
CMD ["./random"]
