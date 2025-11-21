# Dockerfile for Rankle Go - AMD64 and ARM64 only
#
# Build binaries for AMD64 and ARM64:
#   docker build -t rankle-builder .
#   docker run --rm -v $(pwd)/build:/build rankle-builder

FROM golang:1.23-alpine

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build only for AMD64 and ARM64
RUN mkdir -p /output && \
    # Linux AMD64
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
        -ldflags="-w -s -X main.version=dev" \
        -o /output/rankle-linux-amd64 ./cmd/rankle && \
    # Linux ARM64
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build \
        -ldflags="-w -s -X main.version=dev" \
        -o /output/rankle-linux-arm64 ./cmd/rankle && \
    # macOS AMD64 (Intel)
    CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build \
        -ldflags="-w -s -X main.version=dev" \
        -o /output/rankle-darwin-amd64 ./cmd/rankle && \
    # macOS ARM64 (Apple Silicon)
    CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build \
        -ldflags="-w -s -X main.version=dev" \
        -o /output/rankle-darwin-arm64 ./cmd/rankle && \
    # Windows AMD64
    CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
        -ldflags="-w -s -X main.version=dev" \
        -o /output/rankle-windows-amd64.exe ./cmd/rankle && \
    # Generate checksums
    cd /output && sha256sum * > checksums.txt && chmod -R 755 /output

CMD ["sh", "-c", "cp -r /output/* /build/ && echo '✅ Binaries built successfully!' && echo '' && ls -lh /build"]
