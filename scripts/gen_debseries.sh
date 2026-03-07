#!/bin/bash
set -e

update_series() {
  local src_dir="$1"
  local series="$2"

  if [[ ! -d "$src_dir" ]] || [[ -z "$(ls "$src_dir"/*.patch 2>/dev/null)" ]]; then
    return
  fi

  touch "$series"

  for patch in "$src_dir"/*.patch; do
    local name
    name=$(basename "$patch")
    if ! grep -qxF "$name" "$series"; then
      echo "$name" >> "$series"
    fi
  done
}

while [[ $# -gt 0 ]]; do
  src_dir="$1"
  series="$2"
  shift 2
  update_series "$src_dir" "$series"
done
