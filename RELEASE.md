# Release Guide

This document explains how to create releases for Rankle Go following best practices.

## 🏷️ Semantic Versioning

We follow [Semantic Versioning 2.0.0](https://semver.org/):

```
MAJOR.MINOR.PATCH (e.g., v1.2.3)
```

- **MAJOR**: Breaking changes (v1.0.0 → v2.0.0)
- **MINOR**: New features, backward-compatible (v1.0.0 → v1.1.0)
- **PATCH**: Bug fixes, backward-compatible (v1.0.0 → v1.0.1)

## 🔄 Release Process

### 1. Prepare the Release

```bash
# Ensure you're on main branch
git checkout main
git pull origin main

# Run all tests
go test -v -race ./...

# Run pre-commit hooks
pre-commit run --all-files
```

### 2. Update CHANGELOG.md

Add release notes following [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [1.1.0] - 2025-11-20

### Added
- New CDN detection for TransparentEdge
- Support for additional security headers

### Fixed
- DNS timeout handling improved
- TLS certificate chain validation

### Changed
- Updated Go version requirement to 1.23+
```

### 3. Commit Changes

Use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git add CHANGELOG.md
git commit -m "docs: update changelog for v1.1.0"
git push origin main
```

### 4. Create and Push Tag

```bash
# Create annotated tag
git tag -a v1.1.0 -m "Release v1.1.0

- New CDN detection
- Improved DNS timeout handling
- Additional security headers support"

# Push tag to GitHub
git push origin v1.1.0
```

### 5. Automated Release

GitHub Actions will automatically:
1. ✅ Run tests
2. ✅ Build binaries for all platforms (Linux, macOS, Windows)
3. ✅ Generate SHA256 checksums
4. ✅ Create GitHub Release
5. ✅ Upload artifacts
6. ✅ Generate release notes from commits

## 📦 What Gets Released

GoReleaser builds and publishes:

### Platforms

- **Linux**: amd64, arm64
- **macOS**: amd64 (Intel), arm64 (M1/M2)
- **Windows**: amd64

### Artifacts

```
rankle_1.1.0_linux_amd64.tar.gz
rankle_1.1.0_linux_arm64.tar.gz
rankle_1.1.0_darwin_amd64.tar.gz
rankle_1.1.0_darwin_arm64.tar.gz
rankle_1.1.0_windows_amd64.zip
checksums.txt
```

Each archive contains:
- `rankle` (or `rankle.exe` for Windows)
- `LICENSE`
- `README.md`
- `CHANGELOG.md`

## 🔍 Verify Release

After release is created:

```bash
# Download binary
wget https://github.com/javicosvml/rankle-go/releases/download/v1.1.0/rankle_1.1.0_linux_amd64.tar.gz

# Extract
tar -xzf rankle_1.1.0_linux_amd64.tar.gz

# Verify checksum
sha256sum -c checksums.txt

# Test binary
./rankle --version
./rankle example.com
```

## 🎯 Conventional Commit Types

Use these prefixes for automatic changelog generation:

| Prefix | Description | Changelog Section |
|--------|-------------|-------------------|
| `feat:` | New feature | 🚀 Features |
| `fix:` | Bug fix | 🐛 Bug Fixes |
| `docs:` | Documentation | 📚 Documentation |
| `style:` | Code style | (not included) |
| `refactor:` | Refactoring | 🔧 Other Changes |
| `perf:` | Performance | 🔧 Other Changes |
| `test:` | Tests | (not included) |
| `chore:` | Maintenance | (not included) |
| `ci:` | CI/CD | (not included) |

### Examples

```bash
feat: add CloudFront CDN detection
fix: handle DNS timeout errors gracefully
docs: update installation instructions
refactor: simplify detector logic
perf: optimize subdomain discovery
```

## 🔐 Security Releases

For security fixes:

1. Follow the same process
2. Mark as PATCH release (e.g., v1.0.1)
3. Add `[SECURITY]` prefix to changelog entry
4. Notify users via GitHub Security Advisories

Example:

```markdown
## [1.0.1] - 2025-11-20

### Security
- [SECURITY] Fix potential path traversal in report output
```

## 🚨 Pre-release Versions

For testing before official release:

```bash
# Create pre-release tag
git tag -a v1.1.0-beta.1 -m "Beta release v1.1.0-beta.1"
git push origin v1.1.0-beta.1
```

GoReleaser will automatically mark it as pre-release.

## 📋 Release Checklist

Before creating a release:

- [ ] All tests pass: `go test -v ./...`
- [ ] Pre-commit hooks pass: `pre-commit run --all-files`
- [ ] CHANGELOG.md updated with changes
- [ ] Version bump is correct (MAJOR/MINOR/PATCH)
- [ ] No uncommitted changes: `git status`
- [ ] On main branch: `git branch`
- [ ] Latest changes pulled: `git pull`
- [ ] Tag follows format: `vX.Y.Z`
- [ ] Tag annotation includes summary

After release:

- [ ] GitHub Release created successfully
- [ ] All artifacts uploaded (6 binaries + checksums)
- [ ] Release notes are correct
- [ ] Download and test one binary
- [ ] Verify checksums
- [ ] Update documentation if needed
- [ ] Announce release (Twitter, Reddit, etc.)

## 🛠️ Troubleshooting

### Release Failed

Check GitHub Actions logs:
```
https://github.com/javicosvml/rankle-go/actions
```

Common issues:
- Tests failed → Fix tests and re-run
- Build error → Check Go code syntax
- Permission error → Check GITHUB_TOKEN permissions

### Re-create Release

If you need to re-create a release:

```bash
# Delete local tag
git tag -d v1.1.0

# Delete remote tag
git push origin :refs/tags/v1.1.0

# Delete GitHub Release (via web UI or gh CLI)
gh release delete v1.1.0

# Create new tag
git tag -a v1.1.0 -m "Release v1.1.0 (fixed)"
git push origin v1.1.0
```

## 📚 Additional Resources

- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GoReleaser Documentation](https://goreleaser.com/)
- [GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github)

## 🤝 Questions?

If you have questions about the release process:
- Open a [Discussion](https://github.com/javicosvml/rankle-go/discussions)
- Check existing [Releases](https://github.com/javicosvml/rankle-go/releases)
- Read [CHANGELOG.md](CHANGELOG.md)
