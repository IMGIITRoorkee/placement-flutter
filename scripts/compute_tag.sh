#!/usr/bin/env bash

# Work out the git tag for a release.

set -euo pipefail

VERSION_NAME="${1:?usage: compute_tag.sh <version-name> <is_beta>}"
IS_BETA="${2:-false}"

if [[ ! "$VERSION_NAME" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "error: version name '$VERSION_NAME' is not <major>.<minor>.<patch>" >&2
  exit 1
fi
BETA_NUMBER=""
if [ "$IS_BETA" = "true" ]; then
  HIGHEST=0
  while read -r EXISTING; do
    [ -z "$EXISTING" ] && continue
    N="${EXISTING##*-beta.}"
    [[ "$N" =~ ^[0-9]+$ ]] || continue
    [ "$N" -gt "$HIGHEST" ] && HIGHEST="$N"
  done < <(git tag --list "v${VERSION_NAME}-beta.*")

  BETA_NUMBER=$((HIGHEST + 1))
  TAG="v${VERSION_NAME}-beta.${BETA_NUMBER}"
else
  TAG="v${VERSION_NAME}"
fi

# A stable run with bump type 'none' that has nothing to promote would land on
# a tag that already exists, which gh would only reject after the whole build.
if git rev-parse -q --verify "refs/tags/${TAG}" >/dev/null 2>&1; then
  echo "error: tag ${TAG} already exists. Pick a bump type that moves the version name." >&2
  exit 1
fi

echo "$TAG"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  {
    echo "tag=${TAG}"
    echo "beta_number=${BETA_NUMBER}"
  } >>"$GITHUB_OUTPUT"
fi
