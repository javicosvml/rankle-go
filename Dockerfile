# Dockerfile for Rankle Go
#
# Build all platform binaries:
#   docker build -t rankle-builder .
#   docker run --rm -v $(pwd)/build:/build rankle-builder

FROM golang:1.23-alpine

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build for multiple platforms
RUN mkdir -p /output && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
        -ldflags="-w -s -X main.version=1.0.0" \
        -o /output/rankle-linux-amd64 ./cmd/rankle && \
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build \
        -ldflags="-w -s -X main.version=1.0.0" \
        -o /output/rankle-linux-arm64 ./cmd/rankle && \
    CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build \
        -ldflags="-w -s -X main.version=1.0.0" \
        -o /output/rankle-darwin-amd64 ./cmd/rankle && \
    CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build \
        -ldflags="-w -s -X main.version=1.0.0" \
        -o /output/rankle-darwin-arm64 ./cmd/rankle && \
    CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
        -ldflags="-w -s -X main.version=1.0.0" \
        -o /output/rankle-windows-amd64.exe ./cmd/rankle && \
    cd /output && sha256sum * > checksums.txt && chmod -R 755 /output

CMD ["sh", "-c", "cp -r /output/* /build/ && echo '✅ Binaries built successfully!' && ls -lh /build"]
