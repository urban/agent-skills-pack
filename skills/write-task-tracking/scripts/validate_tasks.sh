#!/usr/bin/env bash
set -euo pipefail

required_sections=(
  "Task Summary"
  "Stream Groups"
  "Dependency Map"
  "Tracking Notes"
)

task_path="${1:-}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROVENANCE_SCRIPT="$SCRIPT_DIR/../../document-traceability/scripts/validate_frontmatter_provenance.sh"

if [[ -z "$task_path" ]]; then
  echo "Usage: scripts/validate_tasks.sh <task-artifact-path>"
  exit 1
fi

if [[ ! -f "$task_path" ]]; then
  echo "Error: task artifact not found: $task_path"
  exit 1
fi

bash "$PROVENANCE_SCRIPT" tasks "$task_path"

errors=0

fail() {
  echo "ERROR: $1"
  errors=$((errors + 1))
}

section_block() {
  local section="$1"
  awk -v section="$section" '
    $0 == "## " section { in_section = 1; next }
    in_section && /^## / { exit }
    in_section { print }
  ' "$task_path"
}

prev_line=0
for section in "${required_sections[@]}"; do
  line="$(grep -n -m1 "^## ${section}$" "$task_path" | cut -d: -f1 || true)"
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

task_summary_block="$(section_block "Task Summary")"
for field in "Parent plan:" "Scope:" "Tracking intent:" "Runtime-edge obligations:"; do
  if ! printf "%s\n" "$task_summary_block" | grep -Fq "$field"; then
    fail "Task Summary must include field: ${field}"
  fi
done

stream_groups_block="$(section_block "Stream Groups")"
if ! printf "%s\n" "$stream_groups_block" | grep -Eq '^### '; then
  fail "Stream Groups requires at least one named stream heading"
fi

mapfile -t task_ids < <(printf "%s\n" "$stream_groups_block" | sed -nE 's/^#### Task ([A-Z0-9-]+)$/\1/p')
if (( ${#task_ids[@]} == 0 )); then
  fail "Stream Groups requires at least one task heading in the form '#### Task TASK-ID'"
fi

for task_id in "${task_ids[@]}"; do
  block="$(awk -v task_id="$task_id" '
    $0 == "#### Task " task_id { in_task = 1; next }
    in_task && /^#### Task / { exit }
    in_task { print }
  ' "$task_path")"

  for field in "Title:" "Status:" "Blocked by:" "Plan references:" "What to build:" "Acceptance criteria:" "Notes:"; do
    if ! printf "%s\n" "$block" | grep -Fq "$field"; then
      fail "Task ${task_id} is missing field: ${field}"
    fi
  done

  acceptance_count="$(printf "%s\n" "$block" | awk '
    /^- Acceptance criteria:$/ { in_acceptance = 1; next }
    in_acceptance && /^- [A-Z]/ { exit }
    in_acceptance && /^  - / { count++ }
    END { print count + 0 }
  ')"
  if (( acceptance_count < 2 )); then
    fail "Task ${task_id} must include at least two acceptance-criteria bullets"
  fi
done

dependency_map_block="$(section_block "Dependency Map")"
if ! printf "%s\n" "$dependency_map_block" | grep -Eq '^[[:space:]]*-[[:space:]]+[A-Z0-9-]+[[:space:]]+->[[:space:]]+(.+)$'; then
  fail "Dependency Map requires at least one dependency line in the form '- TASK-ID -> TASK-ID|None'"
fi

tracking_notes_block="$(section_block "Tracking Notes")"
for field in "Active stream:" "Global blockers:" "TODO: Confirm:"; do
  if ! printf "%s\n" "$tracking_notes_block" | grep -Fq "$field"; then
    fail "Tracking Notes must include field: ${field}"
  fi
done

if grep -Eq '\[TODO:[^]]+\]|<[^>]+>' "$task_path"; then
  fail "Task artifact still contains unresolved template placeholders ([TODO: ...] or legacy <...> tokens)"
fi

if (( errors > 0 )); then
  echo
  echo "Validation failed with ${errors} error(s)."
  exit 1
fi

echo "Validation passed."
