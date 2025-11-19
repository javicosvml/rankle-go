<div align="center">

# 🃏 Rankle Go

### Web Infrastructure Reconnaissance Tool

[![Go Version](https://img.shields.io/badge/Go-1.23+-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://go.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?style=for-the-badge&logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Go Report Card](https://goreportcard.com/badge/github.com/javicosvml/rankle-go?style=for-the-badge)](https://goreportcard.com/report/github.com/javicosvml/rankle-go)

*Named after **Rankle, Master of Pranks** from Magic: The Gathering*  
*A legendary faerie who excels at uncovering secrets*

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Development](#️-development) • [Contributing](#-contributing)

</div>

---

## 🎯 Features

<table>
<tr>
<td width="50%">

### 🔍 **Detection Capabilities**
- **CMS Detection**: WordPress, Drupal, Joomla, Magento, Shopify
- **CDN Detection**: Cloudflare, Akamai, Fastly, TransparentEdge (20+)
- **WAF Detection**: Imperva, Sucuri, ModSecurity, F5 BIG-IP (15+)
- **Cloud Providers**: AWS, Azure, GCP, DigitalOcean, and more

</td>
<td width="50%">

### 📊 **Analysis Tools**
- **Technology Stack**: JavaScript libraries, frameworks, servers
- **DNS Analysis**: Complete records (A, AAAA, MX, NS, TXT, CNAME, SOA)
- **TLS/SSL Analysis**: Certificates, protocols, cipher suites
- **Security Headers**: HTTP security headers audit

</td>
</tr>
<tr>
<td width="50%">

### 🌐 **Discovery Features**
- **Subdomain Discovery**: Via Certificate Transparency logs (crt.sh)
- **Passive Reconnaissance**: Non-intrusive scanning
- **Fast & Efficient**: Built with Go for performance

</td>
<td width="50%">

### 📄 **Output Formats**
- **JSON**: Machine-readable for automation
- **Text**: Human-readable console output
- **Structured**: Easy integration with other tools

</td>
</tr>
</table>

## 🚀 Installation

### Option 1: Download Pre-built Binaries ⚡

Download the latest release for your platform from the [Releases](https://github.com/javicosvml/rankle-go/releases) page.

```bash
# Linux/macOS
chmod +x rankle-*
./rankle-* example.com

# Windows
rankle-windows-amd64.exe example.com
```

### Option 2: Install with Go 📦

```bash
go install github.com/javicosvml/rankle-go/cmd/rankle@latest
rankle example.com
```

### Option 3: Build from Source 🔨

**Multi-platform binaries with Docker:**
```bash
git clone https://github.com/javicosvml/rankle-go.git
cd rankle-go

docker build -t rankle-builder .
docker run --rm -v $(pwd)/build:/build rankle-builder

# Binaries available in ./build/ directory
./build/rankle-darwin-arm64 example.com
```

**Single platform (local):**
```bash
go build -o rankle cmd/rankle/main.go
./rankle example.com
```

## 💻 Usage

### Basic Scanning

```bash
# Quick scan
rankle example.com

# Save as JSON
rankle example.com --json

# Save as text report
rankle example.com --text
```

### Example Output

```console
$ rankle example.com

🃏 Rankle - Web Infrastructure Reconnaissance

🎯 Domain:          example.com
🕐 Timestamp:       Tue, 19 Nov 2025 20:30:00 UTC

🌐 HTTP Status:     200 OK
⚡ Response Time:   145ms
🖥️  Server:          nginx/1.18.0

🔍 IP Address:      93.184.216.34
📦 CMS:             WordPress 6.4
📚 Libraries:       jQuery 3.7.1, Bootstrap 5.3
🌐 CDN:             Cloudflare
🛡️  WAF:             Cloudflare WAF

🔐 TLS Version:     TLS 1.3
📜 Certificate:     example.com (Expires: 2026-01-15)
🏢 Issuer:          Let's Encrypt

🔎 Subdomains:      27 found via Certificate Transparency
   • www.example.com
   • api.example.com
   • blog.example.com
   ...

✅ Security Headers:
   • Strict-Transport-Security: max-age=31536000
   • X-Content-Type-Options: nosniff
   • X-Frame-Options: DENY
```

## 🔧 Advanced Usage

<details>
<summary><b>📊 Integration Examples</b></summary>

### Batch Scanning
```bash
# Scan multiple domains
for domain in site1.com site2.com site3.com; do
    rankle "$domain" --json
    sleep 2  # Respectful delay
done
```

### Parse JSON with jq
```bash
rankle example.com --json
cat reports/example_com_rankle.json | jq '.technologies.cms'
cat reports/example_com_rankle.json | jq '.security.tls_version'
```

### CI/CD Integration
```yaml
# GitHub Actions example
- name: Install Rankle
  run: go install github.com/javicosvml/rankle-go/cmd/rankle@latest
  
- name: Security Scan
  run: rankle mysite.com --json
  
- name: Check Results
  run: |
    if jq -e '.security.headers.strict_transport_security' reports/*.json; then
      echo "✅ HSTS enabled"
    else
      echo "❌ HSTS missing"
      exit 1
    fi
```

### Pipeline Integration
```bash
# Jenkins/GitLab CI
rankle production.example.com --json > scan.json
if [ $? -eq 0 ]; then
    echo "Scan completed successfully"
    # Upload to security dashboard
    curl -X POST -d @scan.json https://dashboard.example.com/api/scans
fi
```

</details>

<details>
<summary><b>🎨 Output Format Examples</b></summary>

### JSON Output Structure
```json
{
  "domain": "example.com",
  "timestamp": "2025-11-19T20:30:00Z",
  "http": {
    "status_code": 200,
    "response_time_ms": 145,
    "server": "nginx/1.18.0"
  },
  "technologies": {
    "cms": "WordPress 6.4",
    "libraries": ["jQuery 3.7.1", "Bootstrap 5.3"],
    "cdn": "Cloudflare",
    "waf": "Cloudflare WAF"
  },
  "security": {
    "tls_version": "TLS 1.3",
    "certificate": {
      "subject": "example.com",
      "issuer": "Let's Encrypt",
      "expires": "2026-01-15T00:00:00Z"
    },
    "headers": {
      "strict_transport_security": "max-age=31536000",
      "x_content_type_options": "nosniff"
    }
  },
  "subdomains": {
    "count": 27,
    "list": ["www.example.com", "api.example.com", "..."]
  }
}
```

</details>

## 🛠️ Development

### Prerequisites
- **Go 1.23+** - [Download](https://go.dev/dl/)
- **Docker** - For multi-platform builds
- **pre-commit** - For code quality automation

### Quick Start

```bash
# Clone repository
git clone https://github.com/javicosvml/rankle-go.git
cd rankle-go

# Install pre-commit hooks
pip install pre-commit    # or: brew install pre-commit
pre-commit install

# Run tests
go test -v -race ./...

# Build locally
go build -o rankle cmd/rankle/main.go
./rankle example.com
```

### Pre-commit Hooks 🔒

This project uses **automated pre-commit hooks** to ensure code quality:

<table>
<tr><th>Category</th><th>Checks</th></tr>
<tr>
<td><b>File Checks</b></td>
<td>
• Trailing whitespace removal<br>
• End-of-file fixes<br>
• YAML validation<br>
• Large file prevention<br>
• Merge conflict detection
</td>
</tr>
<tr>
<td><b>Go Formatting</b></td>
<td>
• <code>gofmt</code> - Code formatting<br>
• <code>goimports</code> - Import organization<br>
• <code>go vet</code> - Static analysis<br>
• <code>go mod tidy</code> - Dependency cleanup
</td>
</tr>
<tr>
<td><b>Quality & Security</b></td>
<td>
• <code>golangci-lint</code> - 20+ linters<br>
• <code>go test -race</code> - Race detector<br>
• Security checks (<code>gosec</code>)<br>
• Complexity analysis
</td>
</tr>
</table>

**Commands:**
```bash
# Run all hooks manually
pre-commit run --all-files

# Run specific hook
pre-commit run golangci-lint --all-files

# Update hook versions
pre-commit autoupdate

# Skip hooks (emergencies only)
git commit --no-verify
```

### Project Structure

```
rankle-go/
├── cmd/
│   └── rankle/          # Main application entry point
├── pkg/                 # Public reusable packages
│   ├── scanner/         # Core scanning engine
│   ├── detector/        # Technology detection logic
│   ├── dns/             # DNS operations and queries
│   ├── tls/             # TLS/SSL analysis
│   └── models/          # Data structures and types
├── internal/
│   └── config/          # Internal configuration
├── .pre-commit-config.yaml  # Pre-commit hooks configuration
├── .golangci.yml        # Linting configuration
└── Dockerfile           # Multi-platform build
```

### Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes**
   - Write code following Go idioms
   - Add tests for new functionality
   - Update README.md if needed

3. **Commit** (pre-commit hooks run automatically)
   ```bash
   git add .
   git commit -m "feat: add amazing feature"
   ```

4. **Push and create PR**
   ```bash
   git push origin feature/amazing-feature
   ```

## 🤝 Contributing

We love contributions! Here's how you can help make Rankle even better:

### Ways to Contribute

- 🐛 **Report bugs** - Open an issue with details
- 💡 **Suggest features** - Share your ideas
- 📝 **Improve docs** - Fix typos, add examples
- 🔧 **Submit code** - Fix bugs, add features

### Contribution Process

1. **Fork** the repository
2. **Clone** your fork
   ```bash
   git clone https://github.com/YOUR_USERNAME/rankle-go.git
   ```
3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Install pre-commit**
   ```bash
   pre-commit install
   ```
5. **Make your changes**
   - Write clean, idiomatic Go code
   - Add tests for new functionality
   - Update documentation as needed
6. **Test thoroughly**
   ```bash
   go test -v -race ./...
   pre-commit run --all-files
   ```
7. **Commit** (hooks run automatically)
   ```bash
   git commit -m "feat: add awesome feature"
   ```
8. **Push** and create a **Pull Request**

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `style:` Code style (formatting, semicolons, etc)
- `refactor:` Code refactoring
- `perf:` Performance improvement
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

**Examples:**
```
feat: add support for AWS CloudFront detection
fix: handle timeout errors in DNS queries
docs: add batch scanning examples
```

### Areas for Contribution

<table>
<tr>
<td width="50%">

**🎯 High Priority**
- Additional CMS detection
- New CDN/WAF signatures
- Cloud provider detection
- Performance optimizations

</td>
<td width="50%">

**💡 Nice to Have**
- Additional output formats
- More security checks
- Better error messages
- Code examples

</td>
</tr>
</table>

### Code Guidelines

- ✅ Follow **Effective Go** principles
- ✅ Write tests for new features
- ✅ Keep functions small and focused (≤50 lines)
- ✅ Add godoc comments for exported symbols
- ✅ Handle all errors explicitly
- ✅ Use meaningful variable names
- ❌ Don't add external dependencies (standard library only)

### Questions?

- 💬 Open a [Discussion](https://github.com/javicosvml/rankle-go/discussions)
- 🐛 Report [Issues](https://github.com/javicosvml/rankle-go/issues)
- 📧 Email: contact@rankle-go.example.com

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License - Copyright (c) 2025 Rankle Contributors
```

## ⚠️ Disclaimer

**For educational and authorized security testing only.**

- ✅ Obtain proper authorization before scanning any domain
- ✅ Comply with all applicable laws and regulations
- ✅ Use responsibly and ethically
- ✅ Respect rate limits and robots.txt
- ❌ Not for malicious purposes
- ❌ Not for unauthorized access attempts

**The authors and contributors are not responsible for misuse of this tool.**

## 🙏 Acknowledgments

- 🃏 **Rankle, Master of Pranks** - Magic: The Gathering character inspiration
- 🐍 **Original Python Version** - [javicosvml/rankle](https://github.com/javicosvml/rankle)
- 🏗️ **Built with Go** - 100% standard library, zero external dependencies
- 🔧 **Pre-commit hooks** - [pre-commit.com](https://pre-commit.com)
- 🎯 **TekWizely/pre-commit-golang** - Go hooks implementation
- 📊 **golangci-lint** - Comprehensive Go linting

## 🌟 Star History

If you find this project useful, please consider giving it a ⭐!

[![Star History Chart](https://api.star-history.com/svg?repos=javicosvml/rankle-go&type=Date)](https://star-history.com/#javicosvml/rankle-go&Date)

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/javicosvml/rankle-go?style=social)
![GitHub forks](https://img.shields.io/github/forks/javicosvml/rankle-go?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/javicosvml/rankle-go?style=social)
![GitHub contributors](https://img.shields.io/github/contributors/javicosvml/rankle-go)
![GitHub issues](https://img.shields.io/github/issues/javicosvml/rankle-go)
![GitHub pull requests](https://img.shields.io/github/issues-pr/javicosvml/rankle-go)

## 📦 Release Process

This project uses [GoReleaser](https://goreleaser.com/) for automated releases.

### For Maintainers

To create a new release:

```bash
# Using the helper script
./scripts/release.sh 1.1.0

# Or manually
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

GitHub Actions will automatically:
- ✅ Build binaries for Linux, macOS, Windows (amd64, arm64)
- ✅ Generate SHA256 checksums
- ✅ Create GitHub Release with automated notes
- ✅ Upload all artifacts

See [RELEASE.md](RELEASE.md) for detailed release guidelines.

---

<div align="center">

**🃏 Made with ❤️ by the security community**

[🏠 Repository](https://github.com/javicosvml/rankle-go) • [🐛 Issues](https://github.com/javicosvml/rankle-go/issues) • [📥 Releases](https://github.com/javicosvml/rankle-go/releases) • [💬 Discussions](https://github.com/javicosvml/rankle-go/discussions)

**If you find this tool useful, consider sponsoring or giving it a ⭐!**

</div>
