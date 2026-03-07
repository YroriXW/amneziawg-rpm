#!/bin/bash
set -e

UPSTREAM_KMOD="${1:?Usage: $0 <upstream_kmod> <upstream_tools> <maintainer> <email>}"
UPSTREAM_TOOLS="${2:?}"
MAINTAINER="${3:?}"
EMAIL="${4:?}"

CHANGELOG="CHANGELOG"

if [[ ! -f "$CHANGELOG" ]]; then
  echo "ERROR: $CHANGELOG not found" >&2
  exit 1
fi

gen_deb_changelog() {
  local pkg="$1"
  local upstream="$2"
  local outfile="$3"

  local tmpfile
  tmpfile=$(mktemp)

  while IFS='|' read -r release date text; do
    release="${release// /}"
    date="${date## }"; date="${date%% }"
    text="${text## }"; text="${text%% }"

    local version="${upstream}${release}"

    if grep -q "^${pkg} (${version})" "$outfile" 2>/dev/null; then
      continue
    fi

    {
      echo "${pkg} (${version}) unstable; urgency=medium"
      echo ""
      IFS=';' read -ra items <<< "$text"
      for item in "${items[@]}"; do
        item="${item## }"; item="${item%% }"
        [[ -n "$item" ]] && echo "  * ${item}"
      done
      echo ""
      echo " -- ${MAINTAINER} <${EMAIL}>  ${date}"
      echo ""
    } >> "$tmpfile"

  done < <(grep -v '^#' "$CHANGELOG" | grep -v '^[[:space:]]*$')

  if [[ -s "$tmpfile" ]]; then
    local existing
    existing=$(cat "$outfile" 2>/dev/null || true)
    cat "$tmpfile" > "$outfile"
    [[ -n "$existing" ]] && echo "$existing" >> "$outfile"
    echo "  updated: $outfile"
  else
    echo "  no new entries: $outfile"
  fi

  rm -f "$tmpfile"
}

gen_rpm_changelog() {
  local upstream="$1"
  local specfile="$2"

  if [[ ! -f "$specfile" ]]; then
    echo "  WARN: $specfile not found, skipping" >&2
    return
  fi

  local existing_cl
  existing_cl=$(sed -n '/^%changelog/,${/^%changelog/d;p}' "$specfile")

  local new_entries=""

  while IFS='|' read -r release date text; do
    release="${release// /}"
    date="${date## }"; date="${date%% }"
    text="${text## }"; text="${text%% }"

    local version="${upstream}${release}"
    local rpm_date
    rpm_date=$(date -d "$date" "+%a %b %d %Y" 2>/dev/null || echo "$date")

    if echo "$existing_cl" | grep -q "^\\* .* - ${version}$"; then
      continue
    fi

    local entry
    entry="* ${rpm_date} ${MAINTAINER} <${EMAIL}> - ${version}"$'\n'
    IFS=';' read -ra items <<< "$text"
    for item in "${items[@]}"; do
      item="${item## }"; item="${item%% }"
      [[ -n "$item" ]] && entry+="- ${item}"$'\n'
    done
    entry+=$'\n'

    new_entries+="$entry"

  done < <(grep -v '^#' "$CHANGELOG" | grep -v '^[[:space:]]*$')

  if [[ -n "$new_entries" ]]; then
    local tmpspec
    tmpspec=$(mktemp)
    sed '/^%changelog/,$d' "$specfile" > "$tmpspec"
    echo "%changelog" >> "$tmpspec"
    printf '%s' "$new_entries" >> "$tmpspec"
    [[ -n "$existing_cl" ]] && printf '%s\n' "$existing_cl" >> "$tmpspec"
    mv "$tmpspec" "$specfile"
    echo "  updated: $specfile"
  else
    echo "  no new entries: $specfile"
  fi
}

echo "=== debian/changelog (amneziawg-linux-kmod) ==="
gen_deb_changelog "amneziawg-linux-kmod" "$UPSTREAM_KMOD" "debian/changelog"

echo "=== debian_awgtools/changelog (amneziawg) ==="
gen_deb_changelog "amneziawg" "$UPSTREAM_TOOLS" "debian_awgtools/changelog"

echo "=== amneziawg-kmod.spec ==="
gen_rpm_changelog "$UPSTREAM_KMOD" "amneziawg-kmod.spec"

echo "=== amneziawg-tools.spec ==="
gen_rpm_changelog "$UPSTREAM_TOOLS" "amneziawg-tools.spec"

echo "=== amneziawg.spec ==="
gen_rpm_changelog "$UPSTREAM_KMOD" "amneziawg.spec"

echo ""
echo "Done."
