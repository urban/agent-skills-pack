#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: validate_technical_design.sh <technical-design-file>" >&2
  exit 1
fi

FILE="$1"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROVENANCE_SCRIPT="$SCRIPT_DIR/../../document-traceability/scripts/validate_frontmatter_provenance.sh"

if [[ ! -f "$FILE" ]]; then
  echo "Technical design file not found: $FILE" >&2
  exit 1
fi

bash "$PROVENANCE_SCRIPT" technical-design "$FILE"

required_sections=(
  "## Architecture Summary"
  "## System Context"
  "## Components and Responsibilities"
  "## Data Model and Data Flow"
  "## Interfaces and Contracts"
  "## Integration Points"
  "## Failure and Recovery Strategy"
  "## Security, Reliability, and Performance"
  "## Implementation Strategy"
  "## Testing Strategy"
  "## Risks and Tradeoffs"
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

component_count="$({
  awk '
    /^## Components and Responsibilities$/ { in_components = 1; next }
    in_components && /^## / { exit }
    in_components && /^### / && $0 != "### Behavior State Diagram" { count++ }
    END { print count + 0 }
  ' "$FILE"
} || true)"
if (( component_count < 1 )); then
  echo "Missing at least one named component subsection under Components and Responsibilities" >&2
  exit 1
fi

extract_heading_block() {
  local heading="$1"
  awk -v heading="$heading" '
    $0 == heading { in_block = 1; next }
    in_block && ($0 ~ /^## / || $0 ~ /^### /) { exit }
    in_block { print }
  ' "$FILE"
}

validate_diagram_slot() {
  local heading="$1"
  local diagram_type="$2"
  local block

  if ! grep -Fxq "$heading" "$FILE"; then
    echo "Missing required diagram subsection: $heading" >&2
    exit 1
  fi

  block="$(extract_heading_block "$heading")"
  if [[ -z "$block" ]]; then
    echo "Diagram subsection is empty: $heading" >&2
    exit 1
  fi

  if grep -Eq "^[[:space:]]*-[[:space:]]+Not needed: " <<<"$block"; then
    return 0
  fi

  if grep -Eq 'TODO: Confirm' <<<"$block"; then
    return 0
  fi

  if ! grep -Eq '```mermaid' <<<"$block"; then
    echo "Diagram subsection must include a Mermaid block or 'Not needed:' rationale: $heading" >&2
    exit 1
  fi

  if ! grep -Eq "^[[:space:]]*${diagram_type}( |$)" <<<"$block"; then
    echo "Diagram subsection must use Mermaid type '${diagram_type}': $heading" >&2
    exit 1
  fi
}

validate_diagram_slot '### Context Flowchart' 'flowchart'
validate_diagram_slot '### Behavior State Diagram' 'stateDiagram-v2'
validate_diagram_slot '### Entity Relationship Diagram' 'erDiagram'
validate_diagram_slot '### Interaction Diagram' 'sequenceDiagram'

echo "Technical design validation passed: $FILE"
