# Build stage
FROM golang:1.16-buster AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/docker-hub-ghcr-test

COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o go-exec .


# Run stage
FROM ubuntu:20.04

WORKDIR /usr/src/app

RUN chmod 777 /usr/src/app \
 && apt-get update -qq \
 && DEBIAN_FRONTEND="noninteractive" apt-get install -qq -y tzdata ffmpeg mediainfo

COPY --from=builder /go/src/docker-hub-ghcr-test/go-exec ./go-exec

ENTRYPOINT ["./go-exec"]
