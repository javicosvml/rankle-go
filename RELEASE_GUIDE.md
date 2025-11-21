# 🚀 Release Guide - Rankle Go

## Overview

Rankle uses **GitHub Actions + GoReleaser** for fully automated releases.

**Plataformas soportadas:**
- ✅ Linux AMD64
- ✅ Linux ARM64
- ✅ macOS AMD64 (Intel)
- ✅ macOS ARM64 (Apple Silicon)
- ✅ Windows AMD64

## 📋 Pre-requisitos

Antes de crear una release:

1. ✅ Todos los tests pasando
2. ✅ Pre-commit hooks pasando
3. ✅ CHANGELOG.md actualizado
4. ✅ README.md actualizado (si hay cambios)
5. ✅ Código en `main` branch

## 🎯 Flujo de Release (Completamente Automático)

### Opción 1: Release desde la terminal (Recomendado)

```bash
# 1. Asegúrate de estar en main y actualizado
git checkout main
git pull origin main

# 2. Verifica que todo esté bien
pre-commit run --all-files
go test ./...

# 3. Crea y push el tag (esto dispara el release automáticamente)
git tag -a v1.0.0 -m "Release v1.0.0: Initial release"
git push origin v1.0.0
```

**¡Eso es todo!** GitHub Actions se encarga del resto.

### Opción 2: Release desde GitHub Web UI

1. Ve a tu repositorio en GitHub
2. Click en **"Releases"** en el sidebar derecho
3. Click en **"Create a new release"**
4. Click en **"Choose a tag"** → Escribe el nuevo tag (ej: `v1.0.0`)
5. Click en **"Create new tag: v1.0.0 on publish"**
6. Título: `v1.0.0` (o el nombre que prefieras)
7. Descripción: Se generará automáticamente
8. Click en **"Publish release"**

GitHub Actions detecta el tag y crea el release automáticamente.

## 🔄 Qué Sucede Automáticamente

Cuando haces push de un tag `v*.*.*`:

1. **GitHub Actions se dispara** (`.github/workflows/release.yml`)
2. **Tests se ejecutan** - Asegura que todo funciona
3. **GoReleaser compila** 5 binarios:
   - `rankle-linux-amd64`
   - `rankle-linux-arm64`
   - `rankle-darwin-amd64` (Intel Mac)
   - `rankle-darwin-arm64` (Apple Silicon)
   - `rankle-windows-amd64.exe`
4. **Se crean archives** (.tar.gz para Unix, .zip para Windows)
5. **Se generan checksums** (SHA256)
6. **Release notes automáticos** desde commits
7. **Se publica en GitHub Releases**

## 📦 Estructura de Release

Cada release contendrá:

```
📦 Releases
├── rankle_1.0.0_linux_amd64.tar.gz
├── rankle_1.0.0_linux_arm64.tar.gz
├── rankle_1.0.0_darwin_amd64.tar.gz
├── rankle_1.0.0_darwin_arm64.tar.gz
├── rankle_1.0.0_windows_amd64.zip
├── checksums.txt
└── Source code (zip)
└── Source code (tar.gz)
```

## 🏷️ Versionado Semántico

Seguimos [Semantic Versioning 2.0.0](https://semver.org/):

**Formato:** `vMAJOR.MINOR.PATCH`

- **MAJOR** (v2.0.0): Cambios incompatibles con versiones anteriores
- **MINOR** (v1.1.0): Nueva funcionalidad compatible con versiones anteriores
- **PATCH** (v1.0.1): Bug fixes compatibles

**Ejemplos:**
```bash
git tag -a v1.0.0 -m "Release v1.0.0: Initial release"
git tag -a v1.1.0 -m "Release v1.1.0: Added subdomain enumeration"
git tag -a v1.0.1 -m "Release v1.0.1: Fixed TLS timeout bug"
```

## 📝 Mensajes de Commit para Changelog Automático

GoReleaser agrupa commits automáticamente:

```bash
# Features (🚀 Features)
git commit -m "feat: add subdomain enumeration"
git commit -m "feat(dns): add MX record detection"

# Bug Fixes (🐛 Bug Fixes)
git commit -m "fix: handle timeout errors correctly"
git commit -m "fix(tls): certificate validation error"

# Documentation (📚 Documentation)
git commit -m "docs: update installation guide"

# Otros (🔧 Other Changes)
git commit -m "refactor: improve error handling"
```

## 🧪 Testing Local (Opcional)

Puedes probar el release localmente antes de publicar:

```bash
# Instalar GoReleaser
brew install goreleaser  # macOS
# o
go install github.com/goreleaser/goreleaser/v2@latest

# Probar release (sin publicar)
goreleaser release --snapshot --clean

# Ver binarios generados
ls -lh dist/
```

## 🐳 Build con Docker (Alternativa Manual)

Si prefieres compilar manualmente sin GoReleaser:

```bash
# Build todos los binarios
docker build -t rankle-builder .
docker run --rm -v $(pwd)/build:/build rankle-builder

# Ver binarios
ls -lh build/
```

## 🔍 Verificar Release

Después de crear el release:

1. Ve a: `https://github.com/javicosvml/rankle-go/releases`
2. Verifica que aparezcan 5 binarios + checksums
3. Descarga y prueba un binario:

```bash
# Ejemplo Linux AMD64
wget https://github.com/javicosvml/rankle-go/releases/download/v1.0.0/rankle_1.0.0_linux_amd64.tar.gz
tar -xzf rankle_1.0.0_linux_amd64.tar.gz
./rankle --version
./rankle example.com
```

## 🚨 Troubleshooting

### Error: "Tag already exists"
```bash
# Eliminar tag local y remoto
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0

# Crear nuevo tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Error: "Tests failed"
El release no se creará si los tests fallan.
```bash
# Ejecutar tests localmente
go test -v -race ./...

# Arreglar errores y commit
git commit -am "fix: resolve test failures"
git push origin main

# Intentar release nuevamente
git tag -a v1.0.1 -m "Release v1.0.1"
git push origin v1.0.1
```

### Error: "Permission denied"
Verifica que GitHub Actions tenga permisos:
- Ve a Settings → Actions → General
- "Workflow permissions" → "Read and write permissions"

## 📋 Checklist de Release

Antes de crear un release:

- [ ] Tests pasando: `go test ./...`
- [ ] Pre-commit pasando: `pre-commit run --all-files`
- [ ] CHANGELOG.md actualizado
- [ ] README.md actualizado (si es necesario)
- [ ] Version number decidido (semver)
- [ ] En `main` branch
- [ ] Git clean (no cambios sin commit)

Crear release:

- [ ] `git tag -a vX.Y.Z -m "Release vX.Y.Z: Description"`
- [ ] `git push origin vX.Y.Z`
- [ ] Esperar ~5 minutos (GitHub Actions)
- [ ] Verificar en GitHub Releases
- [ ] Descargar y probar un binario

## 🎉 Ejemplo Completo

```bash
# 1. Preparar release
cd rankle-go
git checkout main
git pull origin main

# 2. Actualizar CHANGELOG.md
vim CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: update changelog for v1.0.0"
git push origin main

# 3. Verificar calidad
pre-commit run --all-files
go test -v ./...

# 4. Crear y publicar tag
git tag -a v1.0.0 -m "Release v1.0.0: Initial public release"
git push origin v1.0.0

# 5. Esperar ~5 minutos y verificar
# https://github.com/javicosvml/rankle-go/releases

# 6. Probar binario
wget https://github.com/javicosvml/rankle-go/releases/download/v1.0.0/rankle_1.0.0_linux_amd64.tar.gz
tar -xzf rankle_1.0.0_linux_amd64.tar.gz
./rankle --version
```

## 📊 Monitorear GitHub Actions

Ver el progreso del release:

1. Ve a: `https://github.com/javicosvml/rankle-go/actions`
2. Click en el workflow "Release"
3. Monitorea el progreso en tiempo real

## 🔗 Links Útiles

- **GoReleaser Docs:** https://goreleaser.com
- **Semantic Versioning:** https://semver.org
- **GitHub Actions:** https://docs.github.com/en/actions
- **Releases:** https://github.com/javicosvml/rankle-go/releases

---

## 📌 Resumen

**Flujo simple:**
1. `git tag -a v1.0.0 -m "Release v1.0.0"`
2. `git push origin v1.0.0`
3. ¡Listo! GitHub Actions hace todo automáticamente

**No hay pasos manuales. Todo es automático.** 🎉
