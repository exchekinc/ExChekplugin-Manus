#!/bin/bash
# ExChek Manus Skills Builder
# Manus requires SKILL.md at the absolute root of the uploaded .zip / .skill file.
# Each output is a flat zip:
#   exchek-<slug>.skill
#   ├── SKILL.md
#   ├── LICENSE.md
#   └── references/
#       └── *.md
#
# Manus does not support bulk import of multiple skills in one zip — each .skill
# file must be uploaded individually via the Manus skills upload modal.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
DIST_DIR="$SCRIPT_DIR/dist"
LICENSE="$SCRIPT_DIR/LICENSE.md"

mkdir -p "$DIST_DIR"

SKILLS=(
  exchek-classify
  exchek-csl
  exchek-license
  exchek-jurisdiction
  exchek-encryption
  exchek-country-risk
  exchek-risk-triage
  exchek-red-flag-assessment
  exchek-deemed-export
  exchek-export-docs
  exchek-ecp
  exchek-audit-lookback
  exchek-compliance-report
  exchek-partner-compliance
  exchek-recordkeeping
  exchek-docx
)

echo "Building ExChek Manus skills..."
echo ""

# Drop a copy of LICENSE.md into each skill directory so it ships inside each .skill
for skill in "${SKILLS[@]}"; do
  cp "$LICENSE" "$SKILLS_DIR/$skill/LICENSE.md"
done

# Build flat .skill files — SKILL.md at the absolute root of the zip
for skill in "${SKILLS[@]}"; do
  skill_dir="$SKILLS_DIR/$skill"
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "  ⚠️  SKIP $skill — no SKILL.md found"
    continue
  fi
  out="$DIST_DIR/$skill.skill"
  rm -f "$out"
  # Zip from inside the skill directory so SKILL.md ends up at the zip root
  (cd "$skill_dir" && zip -r -q "$out" . --exclude "*.DS_Store" --exclude "*__MACOSX*")
  echo "  ✅ $skill.skill"
done

echo ""
echo "Build complete. Output in: $DIST_DIR"
echo ""
echo "Skill count: ${#SKILLS[@]}"
echo ""
echo "--- dist/ ---"
ls -lh "$DIST_DIR"/*.skill 2>/dev/null | awk '{printf "  %-40s %s\n", $NF, $5}'
echo ""
echo "--- Verify each .skill has SKILL.md at the absolute root ---"
for f in "$DIST_DIR"/*.skill; do
  base=$(basename "$f")
  has_root_skill=$(unzip -l "$f" 2>/dev/null | awk '$NF == "SKILL.md" {print "yes"; exit}')
  printf "  %-40s SKILL.md at root: %s\n" "$base" "${has_root_skill:-NO}"
done
