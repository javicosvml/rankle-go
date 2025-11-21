#!/usr/bin/env bash
# Helper script to create a new release
# Usage: ./scripts/create-release.sh v1.0.0 "Initial release"

set -e

VERSION=$1
MESSAGE=$2

if [ -z "$VERSION" ] || [ -z "$MESSAGE" ]; then
    echo "❌ Usage: $0 <version> <message>"
    echo ""
    echo "Examples:"
    echo "  $0 v1.0.0 'Initial release'"
    echo "  $0 v1.1.0 'Add subdomain enumeration'"
    echo "  $0 v1.0.1 'Fix TLS timeout bug'"
    exit 1
fi

# Validate version format
if [[ ! $VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Invalid version format. Use vX.Y.Z (e.g., v1.0.0)"
    exit 1
fi

echo "🚀 Creating release $VERSION"
echo ""

# Check if on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Warning: You're on branch '$CURRENT_BRANCH', not 'main'"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo "❌ You have uncommitted changes. Commit or stash them first."
    git status -s
    exit 1
fi

# Pull latest changes
echo "📥 Pulling latest changes..."
git pull origin $CURRENT_BRANCH

# Run tests
echo "🧪 Running tests..."
go test -v -race ./...

# Run pre-commit hooks
echo "🔍 Running pre-commit hooks..."
pre-commit run --all-files

# Create tag
echo "🏷️  Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION: $MESSAGE"

# Show tag info
echo ""
echo "✅ Tag created:"
git show "$VERSION" --no-patch

echo ""
echo "📋 Next steps:"
echo ""
echo "  1. Push the tag to trigger the release:"
echo "     git push origin $VERSION"
echo ""
echo "  2. Monitor GitHub Actions:"
echo "     https://github.com/javicosvml/rankle-go/actions"
echo ""
echo "  3. Verify the release (~5 minutes):"
echo "     https://github.com/javicosvml/rankle-go/releases"
echo ""
read -p "Push tag now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Pushing tag..."
    git push origin "$VERSION"
    echo ""
    echo "✅ Release triggered!"
    echo ""
    echo "🔗 Monitor progress:"
    echo "   https://github.com/javicosvml/rankle-go/actions"
else
    echo ""
    echo "ℹ️  Tag created locally but not pushed."
    echo "   Push manually with: git push origin $VERSION"
fi
