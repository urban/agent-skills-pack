#!/usr/bin/env bash
set -euo pipefail

required_sections=(
  "Execution Summary"
  "Scope Alignment"
  "Implementation Streams"
  "Work Breakdown"
  "Dependency and Sequencing Strategy"
  "Validation Checkpoints"
  "Risks and Mitigations"
  "Progress Tracking"
  "Further Notes"
)

plan_path="${1:-}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROVENANCE_SCRIPT="$SCRIPT_DIR/../../document-traceability/scripts/validate_frontmatter_provenance.sh"

if [[ -z "$plan_path" ]]; then
  echo "Usage: scripts/validate_plan.sh <plan-path>"
  exit 1
fi

if [[ ! -f "$plan_path" ]]; then
  echo "Error: plan not found: $plan_path"
  exit 1
fi

bash "$PROVENANCE_SCRIPT" plan "$plan_path"

errors=0

fail() {
  echo "ERROR: $1"
  errors=$((errors + 1))
}

has_unresolved_template_placeholders() {
  grep -Eq '\[TODO:[^]]+\]|<[^>]+>' "$plan_path"
}

section_block() {
  local section="$1"
  awk -v section="$section" '
    $0 == "## " section { in_section = 1; next }
    in_section && /^## / { exit }
    in_section { print }
  ' "$plan_path"
}

prev_line=0
for section in "${required_sections[@]}"; do
  line="$(grep -n -m1 "^## ${section}$" "$plan_path" | cut -d: -f1 || true)"
  if [[ -z "$line" ]]; then
    fail "Missing required section: ## ${section}"
    continue
  fi
  if (( line <= prev_line )); then
    fail "Section out of order: ## ${section}"
  fi
  prev_line="$line"

  content="$(section_block "$section" | sed '/^[[:space:]]*$/d' || true)"
  if [[ -z "$content" ]]; then
    fail "Section is empty: ## ${section}"
  fi
done

scope_alignment_block="$(section_block "Scope Alignment")"
for required_ref in "Charter:" "User Stories:" "Requirements:" "Technical Design:" "Story capability areas:" "Story anchors:" "Runtime-edge obligations:"; do
  if ! printf "%s\n" "$scope_alignment_block" | grep -Fq "$required_ref"; then
    fail "Scope Alignment must reference companion artifact or obligation field: ${required_ref}"
  fi
done

if ! printf "%s\n" "$scope_alignment_block" | grep -Eq '^[[:space:]]*-[[:space:]]Story anchors:[[:space:]]*(TODO: Confirm|.*US1\.[0-9]+.*)$'; then
  fail "Scope Alignment must include 'Story anchors:' with one or more US1.x story IDs or TODO: Confirm"
fi

implementation_streams_block="$(section_block "Implementation Streams")"
if ! printf "%s\n" "$implementation_streams_block" | grep -Eq '^### '; then
  fail "Implementation Streams requires at least one named stream heading"
fi

work_breakdown_block="$(section_block "Work Breakdown")"
if ! printf "%s\n" "$work_breakdown_block" | grep -Eq '^[[:space:]]*-[[:space:]]\[[[:space:]xX]\][[:space:]]'; then
  fail "Work Breakdown requires at least one checklist item"
fi

progress_tracking_block="$(section_block "Progress Tracking")"
if ! printf "%s\n" "$progress_tracking_block" | grep -Eq '^[[:space:]]*-[[:space:]]Status:'; then
  fail "Progress Tracking must include a Status line"
fi

if has_unresolved_template_placeholders; then
  fail "Plan still contains unresolved template placeholders ([TODO: ...] or legacy <...> tokens)"
fi

if (( errors > 0 )); then
  echo
  echo "Validation failed with ${errors} error(s)."
  exit 1
fi

echo "Validation passed."
