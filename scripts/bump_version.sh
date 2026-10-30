#!/usr/bin/env bash

# bump version of pubspec.yaml

set -euo pipefail

BUMP_TYPE="${1:-patch}"
PUBSPEC="${2:-pubspec.yaml}"

case "$BUMP_TYPE" in
  major | minor | patch | none) ;;
  *)
    echo "error: unknown bump type '$BUMP_TYPE' (expected major, minor, patch or none)" >&2
    exit 1
    ;;
esac

if [ ! -f "$PUBSPEC" ]; then
  echo "error: $PUBSPEC not found" >&2
  exit 1
fi

CURRENT=$(sed -nE 's/^version:[[:space:]]*([^[:space:]#]+).*/\1/p' "$PUBSPEC" | head -1)

if [[ ! "$CURRENT" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$ ]]; then
  echo "error: version '$CURRENT' in $PUBSPEC is not <major>.<minor>.<patch>+<build>" >&2
  exit 1
fi

MAJOR="${BASH_REMATCH[1]}"
MINOR="${BASH_REMATCH[2]}"
PATCH="${BASH_REMATCH[3]}"
BUILD="${BASH_REMATCH[4]}"

case "$BUMP_TYPE" in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

VERSION_NAME="${MAJOR}.${MINOR}.${PATCH}"
BUILD_NUMBER=$((BUILD + 1))
VERSION="${VERSION_NAME}+${BUILD_NUMBER}"

TMP=$(mktemp)
sed -E "s|^version:[[:space:]]*.*|version: ${VERSION}|" "$PUBSPEC" >"$TMP"
mv "$TMP" "$PUBSPEC"

echo "${CURRENT} -> ${VERSION}"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  {
    echo "version=${VERSION}"
    echo "version_name=${VERSION_NAME}"
    echo "build_number=${BUILD_NUMBER}"
  } >>"$GITHUB_OUTPUT"
fi
