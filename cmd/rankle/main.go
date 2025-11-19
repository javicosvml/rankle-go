package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"

	"github.com/javicosvml/rankle-go/internal/config"
	"github.com/javicosvml/rankle-go/pkg/detector"
	"github.com/javicosvml/rankle-go/pkg/dns"
	"github.com/javicosvml/rankle-go/pkg/models"
	"github.com/javicosvml/rankle-go/pkg/output"
	"github.com/javicosvml/rankle-go/pkg/scanner"
	"github.com/javicosvml/rankle-go/pkg/tls"
)

var (
	// Version information (set by GoReleaser via ldflags)
	version = "dev"
	commit  = "none"
	date    = "unknown"
	builtBy = "manual"

	// CLI flags
	jsonOutput  bool
	textOutput  bool
	outputType  string
	showVersion bool
	showHelp    bool
)

func init() {
	flag.BoolVar(&jsonOutput, "json", false, "Save results as JSON")
	flag.BoolVar(&jsonOutput, "j", false, "Save results as JSON (shorthand)")
	flag.BoolVar(&textOutput, "text", false, "Save results as text report")
	flag.BoolVar(&textOutput, "t", false, "Save results as text report (shorthand)")
	flag.StringVar(&outputType, "output", "", "Save output (json/text/both)")
	flag.StringVar(&outputType, "o", "", "Save output (json/text/both) (shorthand)")
	flag.BoolVar(&showVersion, "version", false, "Show version information")
	flag.BoolVar(&showVersion, "v", false, "Show version information (shorthand)")
	flag.BoolVar(&showHelp, "help", false, "Show help message")
	flag.BoolVar(&showHelp, "h", false, "Show help message (shorthand)")
}

func main() {
	flag.Parse()

	formatter := output.New()

	// Show version
	if showVersion {
		fmt.Printf("🃏 Rankle Go v%s\n", version)
		fmt.Println("   Web Infrastructure Reconnaissance Tool")
		fmt.Println()
		fmt.Printf("   Version:  %s\n", version)
		fmt.Printf("   Commit:   %s\n", commit)
		fmt.Printf("   Built:    %s\n", date)
		fmt.Printf("   Built by: %s\n", builtBy)
		fmt.Println()
		fmt.Println("   Repository: https://github.com/javicosvml/rankle-go")
		os.Exit(0)
	}

	// Show help or no arguments
	if showHelp || flag.NArg() < 1 {
		printUsage(formatter)
		os.Exit(0)
	}

	// Get domain from arguments
	domain := flag.Arg(0)

	// Print banner
	formatter.PrintBanner()

	// Initialize configuration
	cfg := config.Default()

	// Run scan
	result, err := performScan(domain, cfg)
	if err != nil {
		fmt.Fprintf(os.Stderr, "\n❌ Error during scan: %v\n", err)
		os.Exit(1)
	}

	// Print summary
	formatter.PrintSummary(result)

	// Handle output saving
	if err := handleOutput(result, domain, formatter); err != nil {
		fmt.Fprintf(os.Stderr, "\n❌ Error saving output: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("\n🃏 Thank you for using Rankle!")
	fmt.Println(`   "Master of Pranks knows all your secrets..."`)
	fmt.Println()
}

func performScan(domain string, cfg *config.Config) (*models.ScanResult, error) {
	// Initialize components
	scan := scanner.New(cfg)
	det := detector.New()
	dnsResolver := dns.New(cfg)
	tlsAnalyzer := tls.New(cfg)

	// Create result
	result, err := scan.Scan(domain)
	if err != nil {
		return nil, err
	}

	// HTTP Analysis
	fmt.Println("\n🌐 Analyzing HTTP Headers...")
	httpAnalysis, resp, err := scan.AnalyzeHTTP(domain)
	if err != nil {
		fmt.Printf("⚠️  HTTP analysis failed: %v\n", err)
	} else {
		result.HTTP = httpAnalysis

		// Get HTML body for technology detection
		if body, err := scan.GetHTMLBody(resp); err == nil {
			fmt.Println("🔍 Detecting Technologies...")
			result.Technologies = det.DetectTechnologies(body, httpAnalysis.Headers)

			// Extract security headers
			result.SecurityHeaders = extractSecurityHeaders(httpAnalysis.Headers)
		}
	}

	// DNS Analysis
	fmt.Println("🔎 Analyzing DNS Records...")
	dnsAnalysis, err := dnsResolver.Analyze(domain)
	if err != nil {
		fmt.Printf("⚠️  DNS analysis failed: %v\n", err)
	} else {
		result.DNS = dnsAnalysis

		// Detect CDN and WAF
		if result.HTTP != nil {
			result.CDN = det.DetectCDN(result.HTTP.Headers, dnsAnalysis.CNAME)
			result.WAF = det.DetectWAF(result.HTTP.Headers, nil)
		}
	}

	// TLS Analysis
	fmt.Println("🔐 Analyzing TLS Certificate...")
	tlsAnalysis, err := tlsAnalyzer.Analyze(domain)
	if err != nil {
		fmt.Printf("⚠️  TLS analysis failed: %v\n", err)
	} else {
		result.TLS = tlsAnalysis
	}

	// Subdomain Discovery
	fmt.Println("🔍 Discovering Subdomains (Certificate Transparency)...")
	subdomains, err := dnsResolver.EnumerateSubdomains(domain)
	if err != nil {
		fmt.Printf("⚠️  Subdomain discovery failed: %v\n", err)
	} else {
		if len(subdomains) > cfg.Scanner.MaxSubdomainsDisplay {
			result.Subdomains = subdomains[:cfg.Scanner.MaxSubdomainsDisplay]
		} else {
			result.Subdomains = subdomains
		}
		fmt.Printf("   Found %d subdomains\n", len(subdomains))
	}

	// Geolocation (if we have an IP)
	if result.DNS != nil && len(result.DNS.A) > 0 {
		fmt.Println("🌍 Analyzing Geolocation...")
		ip := result.DNS.A[0]

		// Reverse DNS lookup
		if hostnames, err := dnsResolver.ReverseLookup(ip); err == nil && len(hostnames) > 0 {
			hostname := hostnames[0]

			// Detect cloud provider
			isp := ""
			if result.Geolocation != nil {
				isp = result.Geolocation.ISP
			}
			result.CloudProvider = det.DetectCloudProvider(ip, hostname, isp)
		}

		// Note: Geolocation API call would go here
		// For now, we'll just store the IP
		result.Geolocation = &models.Geolocation{
			IP: ip,
		}
	}

	return result, nil
}

func handleOutput(result *models.ScanResult, domain string, formatter *output.Formatter) error {
	// Determine output directory
	outputDir := "reports"
	if _, err := os.Stat("/output/"); err == nil {
		outputDir = "/output"
	}

	// Sanitize domain for filename
	safeDomain := strings.ReplaceAll(domain, ".", "_")

	// Handle command-line flags
	saveJSON := jsonOutput || outputType == "json" || outputType == "both"
	saveText := textOutput || outputType == "text" || outputType == "both"

	if saveJSON {
		jsonPath := filepath.Join(outputDir, safeDomain+"_rankle.json")
		if err := formatter.SaveJSON(result, jsonPath); err != nil {
			return err
		}
	}

	if saveText {
		textPath := filepath.Join(outputDir, safeDomain+"_rankle_report.txt")
		if err := formatter.SaveText(result, textPath); err != nil {
			return err
		}
	}

	return nil
}

func extractSecurityHeaders(headers map[string]string) map[string]string {
	securityHeaders := make(map[string]string)

	securityHeaderKeys := []string{
		"strict-transport-security",
		"content-security-policy",
		"x-frame-options",
		"x-content-type-options",
		"x-xss-protection",
		"referrer-policy",
		"permissions-policy",
	}

	for _, key := range securityHeaderKeys {
		if value, exists := headers[key]; exists {
			securityHeaders[key] = value
		}
	}

	return securityHeaders
}

func printUsage(formatter *output.Formatter) {
	formatter.PrintBanner()

	fmt.Println("\n" + strings.Repeat("=", 80))
	fmt.Println("📖 USAGE")
	fmt.Println(strings.Repeat("=", 80))
	fmt.Println("\n  rankle <domain> [options]")
	fmt.Println("\nEXAMPLES:")
	fmt.Println("  rankle example.com")
	fmt.Println("  rankle https://example.com")
	fmt.Println("  rankle subdomain.example.com")
	fmt.Println("  rankle example.com --json")
	fmt.Println("  rankle example.com --output both")
	fmt.Println("\nOPTIONS:")
	fmt.Println("  -j, --json          Save results as JSON")
	fmt.Println("  -t, --text          Save results as text report")
	fmt.Println("  -o, --output TYPE   Save output (json/text/both)")
	fmt.Println("  -v, --version       Show version information")
	fmt.Println("  -h, --help          Show this help message")
	fmt.Println("\nFEATURES:")
	fmt.Println("  • DNS enumeration and configuration analysis")
	fmt.Println("  • Subdomain discovery via Certificate Transparency")
	fmt.Println("  • Web technology stack detection (CMS, frameworks)")
	fmt.Println("  • TLS/SSL certificate analysis")
	fmt.Println("  • HTTP security headers audit")
	fmt.Println("  • CDN and WAF detection")
	fmt.Println("  • Cloud provider identification")
	fmt.Println("  • JSON and text report export")
	fmt.Println("\nNOTE:")
	fmt.Println("  All reconnaissance is passive and uses public data sources.")
	fmt.Println("  No active scanning or intrusive techniques are employed.")
	fmt.Println(strings.Repeat("=", 80) + "\n")
}
