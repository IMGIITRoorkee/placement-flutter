#!/usr/bin/env bash

# Emit the HTML download table that gets appended to the release notes.

set -euo pipefail

TAG="${1:?usage: gen_downloads_table.sh <tag> <owner/repo> <artifact-prefix>}"
REPO="${2:?owner/repo required}"
PREFIX="${3:?artifact prefix required}"

BASE_URL="https://github.com/${REPO}/releases/download/${TAG}"

link() {
  printf '<a href="%s/%s"><b><code>%s</code></b></a>' "$BASE_URL" "$2" "$1"
}

bullets() {
  printf '<ul style="list-style:none; padding:0; margin:0; text-align:left;">\n'
  for entry in "$@"; do
    IFS='|' read -r label filename <<<"$entry"
    printf '  <li>%s</li>\n' "$(link "$label" "$filename")"
  done
  printf '</ul>'
}

row() {
  local platform="$1"
  shift
  printf '<tr>\n  <td><b>%s</b></td>\n  <td>%s</td>\n</tr>\n' "$platform" "$(bullets "$@")"
}

cat <<EOF

---

<div>
<table>
<tr>
  <th>Platform</th>
  <th>Downloads</th>
</tr>
$(row "Android" \
  "${PREFIX}-arm64-v8a.apk|placement-${PREFIX}-arm64-v8a.apk" \
  "${PREFIX}-armeabi-v7a.apk|placement-${PREFIX}-armeabi-v7a.apk" \
  "${PREFIX}-x86_64.apk|placement-${PREFIX}-x86_64.apk")
</table>
</div>
EOF
