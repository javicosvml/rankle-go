#!/usr/bin/env bash
#
# Release helper script for Rankle Go
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.1.0
#

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version required"
    echo "Usage: $0 <version>"
    echo "Example: $0 1.1.0"
    exit 1
fi

# Add 'v' prefix if not present
if [[ ! $VERSION =~ ^v ]]; then
    VERSION="v$VERSION"
fi

# Validate semantic version format
if ! [[ $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9\.]+)?$ ]]; then
    echo "❌ Error: Invalid version format"
    echo "Expected format: v1.2.3 or v1.2.3-beta.1"
    exit 1
fi

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║              🚀 CREATING RELEASE ${VERSION}                           ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Warning: Not on main branch (currently on: $CURRENT_BRANCH)"
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "❌ Error: Uncommitted changes detected"
    git status -s
    exit 1
fi

echo "✅ No uncommitted changes"

# Pull latest
echo "📥 Pulling latest changes..."
git pull origin main

# Run tests
echo "🧪 Running tests..."
go test -v -race ./... || {
    echo "❌ Tests failed"
    exit 1
}
echo "✅ Tests passed"

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo "❌ Error: Tag $VERSION already exists"
    exit 1
fi

# Confirm release
read -p "Create release $VERSION? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Release cancelled"
    exit 1
fi

# Create and push tag
echo "🏷️  Creating and pushing tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION"
git push origin "$VERSION"
echo "✅ Tag pushed"

echo ""
echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo "║                   🎉 RELEASE PROCESS STARTED                          ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
echo ""
echo "🤖 GitHub Actions is building the release..."
echo "📊 Monitor: https://github.com/javicosvml/rankle-go/actions"
echo "📦 Release: https://github.com/javicosvml/rankle-go/releases/tag/$VERSION"
echo ""
