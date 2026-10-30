#!/usr/bin/env bash

# Write a markdown changelog covering everything landed since the previous
# release.

set -euo pipefail

REPO="${1:?usage: gen_changelog.sh <owner/repo> <is_beta> [output-file]}"
IS_BETA="${2:-false}"
OUT="${3:-changelog.md}"

CURL_ARGS=(--silent --show-error --fail -H "Accept: application/vnd.github+json")
if [ -n "${GITHUB_TOKEN:-}" ]; then
  CURL_ARGS+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

RELEASES=$(curl "${CURL_ARGS[@]}" \
  "https://api.github.com/repos/${REPO}/releases?per_page=30" 2>/dev/null || echo '[]')

if [ "$IS_BETA" = "true" ]; then
  JQ_FILTER='[.[] | select(.draft == false)][0].published_at // empty'
else
  JQ_FILTER='[.[] | select(.draft == false and .prerelease == false)][0].published_at // empty'
fi

SINCE=$(jq -r "$JQ_FILTER" <<<"$RELEASES" 2>/dev/null || true)
LOG_ARGS=(--no-merges --pretty=tformat:'%H%x09%s')
if [ -n "$SINCE" ]; then
  LOG_ARGS+=(--after="$SINCE")
  echo "collecting commits published after ${SINCE}" >&2
else
  PREV_TAG=$(git describe --tags --abbrev=0 2>/dev/null || true)
  if [ -n "$PREV_TAG" ]; then
    LOG_ARGS+=("${PREV_TAG}..HEAD")
    echo "no published release found, collecting commits since tag ${PREV_TAG}" >&2
  else
    LOG_ARGS+=(-n 50)
    echo "no published release or tag found, collecting the last 50 commits" >&2
  fi
fi

COUNT=0
{
  echo "## What's changed"
  echo
  while IFS=$'\t' read -r HASH SUBJECT; do
    [ -z "$HASH" ] && continue
    printf -- '- %s ([`%s`](https://github.com/%s/commit/%s))\n' \
      "$SUBJECT" "${HASH:0:7}" "$REPO" "$HASH"
    COUNT=$((COUNT + 1))
  done < <(git log "${LOG_ARGS[@]}")

  if [ "$COUNT" -eq 0 ]; then
    echo "- No changes since the previous release."
  fi
} >"$OUT"

echo "wrote ${COUNT} commit(s) to ${OUT}" >&2
