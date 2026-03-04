#!/bin/bash
# Runs in the DKMS source tree root before each build.
# $kernelver is set by DKMS to the target kernel version.

set -e

PATCH_FILE="$(dirname "$0")/patches/blake2s.patch"

# Extract major.minor from kernelver (e.g. "6.18.0-amd64" → "6.18")
KVER_MAJOR=$(echo "$kernelver" | cut -d. -f1)
KVER_MINOR=$(echo "$kernelver" | cut -d. -f2)

need_patch() {
    [ "$KVER_MAJOR" -gt 6 ] && return 0
    [ "$KVER_MAJOR" -eq 6 ] && [ "$KVER_MINOR" -ge 18 ] && return 0
    return 1
}

if need_patch; then
    echo "amneziawg: kernel $kernelver >= 6.18, applying blake2s.patch"

    # Idempotency guard: skip if already applied
    if patch --dry-run -p1 -R --quiet < "$PATCH_FILE" 2>/dev/null; then
        echo "amneziawg: blake2s.patch already applied, skipping"
        exit 0
    fi

    patch -p1 < "$PATCH_FILE"
    echo "amneziawg: blake2s.patch applied successfully"
else
    echo "amneziawg: kernel $kernelver < 6.18, blake2s.patch not needed"
fi
