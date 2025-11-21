# Rankle Go - Copilot Instructions

## 📋 Project Context
**Rankle** is a high-performance web infrastructure reconnaissance tool written in Go.
Named after Rankle, Master of Pranks from Magic: The Gathering - a legendary faerie who excels at uncovering secrets.

## 🎯 Core Functionality
- **Purpose**: Passive reconnaissance and technology detection for web infrastructure
- **Main features**: CMS detection, technology fingerprinting, cloud provider detection, CDN/WAF detection, DNS analysis, subdomain discovery, TLS/SSL analysis, security headers audit
- **Output formats**: JSON and human-readable text reports

## 🏗️ Project Structure
```
cmd/rankle/          # Main application entry point
pkg/                 # Public reusable packages
├── scanner/         # Core scanning engine
├── detector/        # Technology detection logic
├── dns/            # DNS operations and queries
├── tls/            # TLS/SSL analysis
└── models/         # Data structures and types
internal/config/     # Internal configuration (not exposed)
```

## 💻 Tech Stack & Standards
- **Language**: Go 1.23+
- **Dependencies**: 100% Go standard library (NO external dependencies)
- **Build**: Docker for multi-platform, `go build` for local development
- **Quality**: Pre-commit hooks with `golangci-lint` (20+ linters automated)

## 📚 Documentation Rules

### Essential Files ONLY
- ✅ **README.md** - How to use and build (main documentation)
- ✅ **LICENSE** - MIT License
- ✅ **Dockerfile, go.mod, go.sum** - Technical files
- ✅ **.pre-commit-config.yaml, .golangci.yml** - Code quality tools
- ✅ **.goreleaser.yml** - Automated release configuration
- ✅ **SECURITY.md** - Security policy (GitHub standard)
- ✅ **CODE_OF_CONDUCT.md** - Community guidelines (GitHub standard)
- ✅ **CHANGELOG.md** - Version history (Keep a Changelog format)

### Forbidden Files
**NEVER create these:**
- ❌ **BUILD.md, CONTRIBUTING.md** - Goes in README.md
- ❌ **AUTHORS.md, RELEASE_GUIDE.md** - Unnecessary, info in README
- ❌ **DIRENV_SETUP.md, GITHUB_ACTIONS.md** - Development info in README
- ❌ **Makefile** - Use Docker or `go build` directly
- ❌ **build.sh, install.sh, setup.sh** - Document commands in README.md
- ❌ **TODO.md, NOTES.md** - Use GitHub Issues/Projects
- ❌ **Any .txt files** - Use Markdown only
- ❌ **Any temporary or planning files** - Work in memory

### After EVERY Task
1. Update README.md if features/usage/build changed
2. Delete any temporary files created
3. Test all commands in README.md
4. Keep repository root clean (only essential files)

## 📐 Coding Standards (Go 1.23+)

### Go Idioms
- Follow **Effective Go** and **Go Code Review Comments**
- Use `gofmt`, `goimports`, `go vet` always
- Error handling: Never ignore errors, wrap with context
- Naming: Short for narrow scope, descriptive for wider scope
- Interfaces: Use `-er` suffix (Reader, Writer, Scanner)
- Exported: Capital for public, lowercase for private

### Error Handling
- Always check errors: `if err != nil`
- Wrap with context: `fmt.Errorf("operation failed: %w", err)`
- Return errors as last value
- Prefer early returns over nested checks

### Code Style
- Functions: Small and focused (≤50 lines ideal)
- DRY: Extract common logic
- KISS: Simple over clever
- Composition over inheritance
- Pass dependencies explicitly, no globals

### Architecture (SOLID for Go)
- Single Responsibility: One purpose per package/struct/function
- Open/Closed: Use interfaces for extensibility
- Interface Segregation: Small, focused interfaces
- Dependency Inversion: Depend on interfaces, not concrete types
- Separation of concerns: scanner, detector, dns, tls are separate

### Concurrency
- "Don't communicate by sharing memory; share memory by communicating"
- Use channels, `sync.WaitGroup`, `sync.Mutex` appropriately
- Never use `time.Sleep()` for synchronization
- Always handle goroutine cleanup with context
- Test with `go test -race`

### Testing
- Table-driven tests with `t.Run()`
- Mock external dependencies (DNS, HTTP)
- Test error paths, not just happy paths
- Run before committing: `go test -v -race ./...`

### Documentation
- **Godoc**: Every exported symbol MUST have a comment
- Start with the symbol name, full sentence
- Example: `// Scanner performs web infrastructure reconnaissance.`
- **README.md**: Update for user-facing changes
- Self-documenting code: Clear naming over comments

## 🚫 What NOT to Do

### Code Anti-Patterns
- ❌ Don't skip `go fmt`, `go vet`, `go test -race`
- ❌ Don't use Makefile or .sh scripts
- ❌ Don't add external dependencies (violates core philosophy)
- ❌ Don't modify working code unnecessarily
- ❌ Don't ignore errors
- ❌ Don't use global variables for state
- ❌ Don't use `panic()` for normal errors
- ❌ Don't embed `context.Context` in structs
- ❌ Don't use `time.Sleep()` for synchronization
- ❌ Don't create `util`, `common`, `helpers` packages
- ❌ Don't write clever code - write obvious code

### Documentation Anti-Patterns
- ❌ **Don't create extra .md files** - Everything in README.md
- ❌ Don't skip README.md updates when changing code
- ❌ Don't leave obsolete files after refactoring
- ❌ Don't leave untested commands in documentation
- ❌ Don't complete a task without reviewing README.md

## 🔍 When Adding Features
1. Check if it fits "passive reconnaissance" philosophy
2. Ensure it doesn't require external dependencies
3. Add detection logic to pkg/detector/
4. Update models in pkg/models/ if needed
5. Add tests for new functionality
6. **Update README.md** with new feature documentation

## 🤖 AI Assistant Guidelines
When helping with this project, you MUST:
- ✅ Follow Effective Go and Go idioms
- ✅ Prioritize standard library over external packages
- ✅ Write simple, maintainable code
- ✅ Always consider security implications
- ✅ Maintain "zero external dependencies" philosophy
- ✅ Use Go 1.23+ features when appropriate
- ✅ **Update README.md after EVERY task**
- ✅ **Delete obsolete files immediately**
- ✅ **Keep repository root clean**
- ✅ **Test all commands before completing tasks**
- ✅ Handle ALL errors explicitly
- ✅ Use `context.Context` for cancellation/timeouts
- ✅ Run `go test -race` to verify concurrency safety
- ✅ Keep functions small (≤50 lines)
- ✅ Prefer early returns

### Task Completion Checklist
Before completing ANY task:
1. [ ] Pre-commit hooks pass: `pre-commit run --all-files`
2. [ ] All exported symbols have godoc comments
3. [ ] All errors are handled
4. [ ] No external dependencies added
5. [ ] **README.md updated if needed**
6. [ ] **No obsolete files in repository root**
7. [ ] **All command examples tested and working**

**Note**: Pre-commit automatically checks formatting, linting, tests, and more.

## 📦 Release Process
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Document changes in README.md
- Build: `docker build -t rankle-builder . && docker run --rm -v $(pwd)/build:/build rankle-builder`
- Binaries in `./build/` with checksums
- Test on multiple platforms if possible

---

**Remember**:
- Everything goes in README.md
- No extra documentation files
- Keep it simple
- Always test your changes
