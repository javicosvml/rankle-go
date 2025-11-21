# Pull Request

## 📋 Description
<!-- Provide a detailed description of your changes -->

## 🎯 Type of Change
<!-- Mark the relevant option with an "x" -->

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📝 Documentation update
- [ ] 🎨 Code style update (formatting, renaming)
- [ ] 🔧 Refactoring (no functional changes)
- [ ] ⚡ Performance improvement
- [ ] ✅ Test update
- [ ] 🔨 Build/CI update
- [ ] 📦 Dependency update

## 🔗 Related Issues
<!-- Link related issues here -->

Fixes #(issue number)
Closes #(issue number)
Related to #(issue number)

## 🧪 Testing
<!-- Describe the tests you ran to verify your changes -->

### Test Configuration
- **OS**: <!-- macOS, Linux, Windows -->
- **Go Version**: <!-- go version -->

### Test Commands
```bash
# Commands used to test
go test -v -race ./...
pre-commit run --all-files
```

### Test Results
```
Paste test output here
```

## 📸 Screenshots
<!-- If applicable, add screenshots to demonstrate the changes -->

## ✅ Checklist
<!-- Mark completed items with an "x" -->

### Code Quality
- [ ] My code follows the project's style guidelines (Effective Go)
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code in hard-to-understand areas
- [ ] My changes generate no new warnings
- [ ] Pre-commit hooks pass: `pre-commit run --all-files`

### Testing
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally: `go test -v ./...`
- [ ] I have tested with race detector: `go test -race ./...`

### Documentation
- [ ] I have updated the README.md if needed
- [ ] I have added/updated godoc comments for exported symbols
- [ ] I have updated CHANGELOG.md
- [ ] I have added usage examples if applicable

### Dependencies
- [ ] I have NOT added external dependencies (standard library only)
- [ ] I have run `go mod tidy` and committed changes

### Breaking Changes
- [ ] I have documented any breaking changes
- [ ] I have updated version number appropriately

## 💭 Additional Notes
<!-- Add any additional notes for reviewers -->

## 📦 Release Notes
<!-- Provide a summary for release notes (optional) -->

```markdown
### Added
-

### Changed
-

### Fixed
-
```

---

**By submitting this pull request, I confirm that my contribution is made under the terms of the MIT license.**
