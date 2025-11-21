#!/usr/bin/env bash
# Install golangci-lint for pre-commit hooks
set -e

echo "🔧 Installing golangci-lint..."

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map architecture names
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
esac

# Install based on OS
if [ "$OS" = "darwin" ]; then
    echo "📦 Installing via Homebrew..."
    brew install golangci-lint
elif [ "$OS" = "linux" ]; then
    echo "📦 Installing via binary..."
    VERSION="v1.62.2"
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $VERSION
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

# Verify installation
if command -v golangci-lint &> /dev/null; then
    echo "✅ golangci-lint installed successfully!"
    golangci-lint --version
else
    echo "❌ Installation failed"
    exit 1
fi
