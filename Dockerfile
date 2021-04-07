# Build stage
FROM golang:1.16-buster AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /go/src/docker-hub-ghcr-test

COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o go-exec .


# Run stage
FROM scratch

WORKDIR /usr/src/app

COPY --from=builder /go/src/docker-hub-ghcr-test/go-exec ./go-exec

ENTRYPOINT ["./go-exec"]
