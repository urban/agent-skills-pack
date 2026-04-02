#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: validate_charter.sh <charter-file>" >&2
  exit 1
fi

FILE="$1"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROVENANCE_SCRIPT="$SCRIPT_DIR/../../document-traceability/scripts/validate_frontmatter_provenance.sh"

if [[ ! -f "$FILE" ]]; then
  echo "Charter file not found: $FILE" >&2
  exit 1
fi

bash "$PROVENANCE_SCRIPT" charter "$FILE"

required_sections=(
  "## Goals"
  "## Non-Goals"
  "## Personas / Actors"
  "## Success Criteria"
)

prev_line=0
for section in "${required_sections[@]}"; do
  line="$(grep -nF "$section" "$FILE" | head -n1 | cut -d: -f1 || true)"
  if [[ -z "$line" ]]; then
    echo "Missing required section: $section" >&2
    exit 1
  fi
  if (( line <= prev_line )); then
    echo "Section out of order: $section" >&2
    exit 1
  fi
  prev_line=$line
done

if ! grep -Eq '^[[:space:]]*-[[:space:]]+.+$' "$FILE"; then
  echo "Missing at least one bullet item" >&2
  exit 1
fi

if ! awk '
  /^## Goals$/ { in_goals = 1; next }
  in_goals && /^## / { exit }
  in_goals && /^[[:space:]]*-[[:space:]]+/ { found = 1 }
  END { exit(found ? 0 : 1) }
' "$FILE"; then
  echo "Missing at least one goal bullet" >&2
  exit 1
fi

if ! grep -Eq '^[[:space:]]*-[[:space:]]+SC1\.[0-9]+:' "$FILE"; then
  echo "Missing at least one success criterion with SC1.x numbering" >&2
  exit 1
fi

echo "Charter validation passed: $FILE"
