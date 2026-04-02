#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: validate_requirements.sh <requirements-file>" >&2
  exit 1
fi

FILE="$1"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROVENANCE_SCRIPT="$SCRIPT_DIR/../../document-traceability/scripts/validate_frontmatter_provenance.sh"

if [[ ! -f "$FILE" ]]; then
  echo "Requirements file not found: $FILE" >&2
  exit 1
fi

bash "$PROVENANCE_SCRIPT" requirements "$FILE"

required_sections=(
  "## Functional Requirements"
  "## Non-Functional Requirements"
  "## Technical Constraints"
  "## Data Requirements"
  "## Integration Requirements"
  "## Dependencies"
  "## Further Notes"
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

if ! grep -Eq '^[[:space:]]*-[[:space:]]+FR1\.[0-9]+:' "$FILE"; then
  echo "Missing at least one functional requirement with FR1.x numbering" >&2
  exit 1
fi

echo "Requirements validation passed: $FILE"
