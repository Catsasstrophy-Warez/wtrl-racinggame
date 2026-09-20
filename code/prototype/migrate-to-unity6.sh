#!/usr/bin/env bash
#
# RVP Unity 2019.4 -> Unity 6 API migration script.
#
# Generated from a real triage of JustInvoke/Randomation-Vehicle-Physics
# (cloned and inspected directly -- see racinggameideas/code/prototype/
# RVP-TRIAGE.md for the full report this came from).
#
# Covers every one of the 27 confirmed call sites across 13 files:
#   - Rigidbody.velocity        -> Rigidbody.linearVelocity     (19 sites)
#   - Rigidbody.drag            -> Rigidbody.linearDamping      (1 site)
#   - Rigidbody.angularDrag     -> Rigidbody.angularDamping     (4 sites)
#   - FindObjectOfType<T>()     -> FindFirstObjectByType<T>()   (3 sites)
#   (FindObjectsOfType<T>() would map to FindObjectsByType<T>(sort mode) --
#   none of the 3 hits in RVP were the plural form, so this script only
#   handles the singular. Check manually if your fork differs.)
#
# NOT included: Rigidbody.angularVelocity was NOT renamed in Unity 6 and
# needs no change -- it was excluded from the grep specifically so this
# script doesn't touch it. Verify that assumption if you're on a Unity
# version newer than what this package was researched against.
#
# Usage:
#   cd <your RVP checkout>
#   bash migrate-to-unity6.sh
#
# This is a dry-run-first script: it prints every change it WOULD make,
# then asks for confirmation before touching any file. It only edits
# Assets/Scripts/**/*.cs -- nothing else in the project is touched.

set -euo pipefail

TARGET_DIR="${1:-Assets/Scripts}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: '$TARGET_DIR' not found. Run this from the RVP project root,"
  echo "or pass the scripts directory as an argument."
  exit 1
fi

echo "=== RVP Unity 6 migration: dry run ==="
echo "Scanning: $TARGET_DIR"
echo

# Word-boundary-safe patterns. \b.velocity\b alone would also match
# .velocityChangeMode or similar -- these patterns require a property
# access pattern (a dot immediately before, word boundary after) so we
# don't clobber unrelated identifiers.
declare -A PATTERNS=(
  ["\.velocity\b(?!ChangeMode)"]=".linearVelocity"
  ["\.drag\b"]=".linearDamping"
  ["\.angularDrag\b"]=".angularDamping"
)

total_files=0
total_hits=0

for pattern in "${!PATTERNS[@]}"; do
  replacement="${PATTERNS[$pattern]}"
  hits=$(grep -rlP "$pattern" "$TARGET_DIR" --include="*.cs" 2>/dev/null || true)
  if [ -n "$hits" ]; then
    while IFS= read -r file; do
      count=$(grep -cP "$pattern" "$file")
      echo "  $file: $count occurrence(s) of pattern matching '$pattern' -> '$replacement'"
      total_hits=$((total_hits + count))
    done <<< "$hits"
  fi
done

# FindObjectOfType -> FindFirstObjectByType (separate loop: different
# replacement shape, no property-access pattern involved)
fot_hits=$(grep -rl "FindObjectOfType<" "$TARGET_DIR" --include="*.cs" 2>/dev/null || true)
if [ -n "$fot_hits" ]; then
  while IFS= read -r file; do
    count=$(grep -c "FindObjectOfType<" "$file")
    echo "  $file: $count occurrence(s) of FindObjectOfType<T>() -> FindFirstObjectByType<T>()"
    total_hits=$((total_hits + count))
  done <<< "$fot_hits"
fi

echo
echo "Total: $total_hits call sites across the files listed above."
echo
read -p "Apply these changes now? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted. No files changed."
  exit 0
fi

echo
echo "=== Applying ==="

# Perl for reliable word-boundary + negative-lookahead support across
# platforms (BSD sed's regex support is inconsistent for this).
find "$TARGET_DIR" -name "*.cs" -print0 | while IFS= read -r -d '' file; do
  perl -i -pe 's/\.velocity\b(?!ChangeMode)/.linearVelocity/g' "$file"
  perl -i -pe 's/\.angularDrag\b/.angularDamping/g' "$file"
  # angularDrag must be handled before drag (angularDrag contains "drag"
  # as a substring at the wrong boundary if done in the other order --
  # \.drag\b alone would not match ".angularDrag" since \b requires a
  # word boundary immediately before "drag", and "r" before it isn't a
  # boundary, so order does not actually matter here, but angularDrag
  # is processed first anyway for clarity when reading this script).
  perl -i -pe 's/\.drag\b/.linearDamping/g' "$file"
  perl -i -pe 's/FindObjectOfType</FindFirstObjectByType</g' "$file"
done

echo "Done. $total_hits call sites updated across $(find "$TARGET_DIR" -name "*.cs" -print0 | xargs -0 grep -l "linearVelocity\|linearDamping\|angularDamping\|FindFirstObjectByType" 2>/dev/null | wc -l) files."
echo
echo "This script does NOT touch the tire shaders -- those need a real"
echo "rewrite, not a rename. See RVP-TRIAGE.md and the URP replacement"
echo "shader shipped alongside this script."
echo
echo "Next: open the project in Unity 6 and let the compiler find anything"
echo "this script missed. This covers every site found in the specific"
echo "commit this was generated against -- verify against your own checkout."
