#!/usr/bin/env bash
set -euo pipefail

# Build an unsigned XPI from the current folder.
# Includes: manifest.json, content.js, content.css, icons/
# Output:  dist/<name>-<version>.xpi

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

# Requirements
command -v zip >/dev/null 2>&1 || { echo "Error: 'zip' is required."; exit 1; }
mkdir -p dist
pushd src
# Derive name/version from manifest.json (prefer jq if present)
if command -v jq >/dev/null 2>&1; then
  NAME="$(jq -r '.name' manifest.json 2>/dev/null | tr ' ' '-' | tr -cd 'A-Za-z0-9._-')"
  VERSION="$(jq -r '.version' manifest.json 2>/dev/null)"
else
  # Fallback: quick-n-dirty grep/sed
  NAME="$(grep -oE '\"name\"\\s*:\\s*\"[^\"]+\"' manifest.json | head -1 | sed 's/.*:\"\\([^\"]*\\)\"/\\1/' | tr ' ' '-' | tr -cd 'A-Za-z0-9._-')"
  VERSION="$(grep -oE '\"version\"\\s*:\\s*\"[^\"]+\"' manifest.json | head -1 | sed 's/.*:\"\\([^\"]*\\)\"/\\1/')"
fi

[ -n "${NAME:-}" ] || NAME="extension"
[ -n "${VERSION:-}" ] || VERSION="0.0.0"
BASENAME="${NAME}-${VERSION}"
# Check required files
for f in manifest.json content.js content.css; do
  [ -f "$f" ] || { echo "Missing required file: $f"; exit 1; }
done


OUT="../dist/${BASENAME}.zip"
rm -f "$OUT"

# -r recurse, -FS make zip deterministic (omit extra file attrs)
zip -r -FS "$OUT" "." -x '**/.DS_Store' '**/Thumbs.db'

popd
cp "dist/${BASENAME}.zip" "dist/${BASENAME}.xpi"
echo "Built: $OUT"
echo "Note: This ZIP is unsigned. For persistent install, sign it via AMO."