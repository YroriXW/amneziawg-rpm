#!/bin/bash
set -e
PATCH_FILE="$(dirname "$0")/patches/blake2s.patch"
KVER_MAJOR=$(echo "$kernelver" | cut -d. -f1)
KVER_MINOR=$(echo "$kernelver" | cut -d. -f2)

need_patch() {
    # Patch needed only on 6.19+: that's when blake2s_ctx (new API) was introduced
    [ "$KVER_MAJOR" -gt 6 ] || { [ "$KVER_MAJOR" -eq 6 ] && [ "$KVER_MINOR" -ge 19 ]; }
}

if need_patch; then
    echo "amneziawg: kernel $kernelver >= 6.19 with new blake2s API, applying blake2s.patch"
    patch -p1 -N --batch --quiet < "$PATCH_FILE" && \
        echo "amneziawg: blake2s.patch applied successfully" || \
        echo "amneziawg: blake2s.patch already applied, skipping"
else
    echo "amneziawg: kernel $kernelver does not need blake2s.patch"
fi
