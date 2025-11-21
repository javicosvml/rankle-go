# 🔧 direnv Setup for Rankle Go

## Quick Start

direnv automatically loads project-specific environment variables when you enter this directory.

### 1. One-Time Setup (if not done)

Add to your `~/.zshrc` (or `~/.bashrc`):
```bash
eval "$(direnv hook zsh)"
```

Reload shell:
```bash
source ~/.zshrc
```

### 2. Allow .envrc

First time in this directory:
```bash
direnv allow
```

Done! Environment loads automatically when you `cd` here.

## What It Does

✅ **Isolated GOPATH**: `$PWD/.gopath` - Project-specific workspace
✅ **Local binaries**: `$PWD/.gopath/bin` - Tools install here
✅ **Go version**: Uses asdf for correct Go version
✅ **Build cache**: `$PWD/.gocache` - Faster builds
✅ **Dev variables**: Debug mode enabled automatically

## Environment Variables Set

- `GOPATH=$PWD/.gopath` - Local Go workspace
- `GOBIN=$GOPATH/bin` - Binary installation directory
- `GOCACHE=$PWD/.gocache` - Build cache
- `RANKLE_DEV=1` - Development mode
- `RANKLE_LOG_LEVEL=debug` - Debug logging

## Verify It's Working

```bash
cd /path/to/rankle-go
# You should see: "✅ Rankle Go environment activated"

echo $GOPATH
# Should show: /path/to/rankle-go/.gopath

go env GOPATH
# Should match GOPATH above
```

## Custom Settings (Optional)

Create `.envrc.local` for personal overrides:
```bash
export RANKLE_LOG_LEVEL=trace
export MY_API_KEY=secret
```

## Troubleshooting

**Environment not loading?**
```bash
direnv status  # Check status
direnv allow   # Re-allow if blocked
```

**Want to disable temporarily?**
```bash
direnv deny    # Disable
direnv allow   # Re-enable
```

## More Info

Full documentation: https://direnv.net/

---

**Why direnv?** It's like Python's virtualenv but for any language. Your global environment stays clean, and the project environment activates automatically.
