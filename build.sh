#!/bin/bash
# ExChek Manus Skills Builder
# Packages all 16 skills into:
#   - Individual .skill files (one per skill, each containing SKILL.md + LICENSE.md + references/)
#   - One combined exchek-all-skills.zip (for bulk import — also includes top-level README/LICENSE/SECURITY/CONTRIBUTING)
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"
DIST_DIR="$SCRIPT_DIR/dist"
LICENSE="$SCRIPT_DIR/LICENSE.md"

mkdir -p "$DIST_DIR/individual"

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

# Drop a copy of LICENSE.md into each skill directory so it ships with each .skill
for skill in "${SKILLS[@]}"; do
  cp "$LICENSE" "$SKILLS_DIR/$skill/LICENSE.md"
done

# Build individual .skill files
for skill in "${SKILLS[@]}"; do
  skill_dir="$SKILLS_DIR/$skill"
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "  ⚠️  SKIP $skill — no SKILL.md found"
    continue
  fi
  out="$DIST_DIR/individual/$skill.skill"
  rm -f "$out"
  (cd "$SKILLS_DIR" && zip -r -q "$out" "$skill/" --exclude "*.DS_Store" --exclude "*__MACOSX*")
  echo "  ✅ $skill.skill"
done

echo ""

# Build combined zip (all 16 skill dirs + top-level README/LICENSE/SECURITY/CONTRIBUTING)
COMBINED="$DIST_DIR/exchek-all-skills.zip"
rm -f "$COMBINED"

# Stage in a temp dir so the top-level docs and skill dirs end up at the zip root
STAGE=$(mktemp -d)
trap "rm -rf $STAGE" EXIT
cp "$SCRIPT_DIR/README.md"       "$STAGE/"
cp "$SCRIPT_DIR/LICENSE.md"      "$STAGE/"
cp "$SCRIPT_DIR/SECURITY.md"     "$STAGE/"
cp "$SCRIPT_DIR/CONTRIBUTING.md" "$STAGE/"
for skill in "${SKILLS[@]}"; do
  cp -R "$SKILLS_DIR/$skill" "$STAGE/"
done
(cd "$STAGE" && zip -r -q "$COMBINED" . --exclude "*.DS_Store" --exclude "*__MACOSX*")

echo "  ✅ exchek-all-skills.zip (bulk import)"
echo ""
echo "Build complete. Output in: $DIST_DIR"
echo ""
echo "Skill count: ${#SKILLS[@]}"
echo ""
echo "--- dist/individual/ ---"
ls -lh "$DIST_DIR/individual/" | tail -n +2 | awk '{printf "  %-40s %s\n", $NF, $5}'
echo ""
SIZE=$(du -sh "$COMBINED" | cut -f1)
printf "  %-40s %s\n" "exchek-all-skills.zip" "$SIZE"
echo ""
echo "--- exchek-all-skills.zip top-level ---"
unzip -l "$COMBINED" | awk '$NF !~ "/" {print "  " $NF}' | grep -v "^  $" | grep -v "^  Name$" | grep -v "^  -" | sort -u | head -20
echo ""
echo "--- SKILL.md files in bulk zip ---"
unzip -l "$COMBINED" | grep "SKILL.md" | awk '{print "  " $NF}'
