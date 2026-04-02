#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
report_path="${1:-}"

required_sections=(
  "Executive Summary"
  "Stakeholder-Ready Product Narratives"
  "Epic Map"
  "Coverage Gaps"
  "Additional Notes"
)

resolve_story_validator() {
  local validator="${script_dir}/../../write-user-stories/scripts/validate_story.sh"
  if [[ -x "${validator}" ]]; then
    printf '%s\n' "${validator}"
    return 0
  fi

  return 1
}

if [[ -z "${report_path}" ]]; then
  echo "Usage: scripts/validate_report.sh <report-path>"
  exit 1
fi

if [[ ! -f "${report_path}" ]]; then
  echo "Error: report not found: ${report_path}"
  exit 1
fi

story_validator="$(resolve_story_validator || true)"
if [[ -z "${story_validator}" ]]; then
  echo "Error: write-user-stories validator not found"
  exit 1
fi

errors=0

fail() {
  echo "ERROR: $1"
  errors=$((errors + 1))
}

has_unresolved_template_placeholders() {
  grep -Eq '\[TODO:[^]]+\]|<[^>]+>' "$report_path"
}

section_block() {
  local section="$1"
  awk -v section="$section" '
    $0 == "## " section { in_section = 1; next }
    in_section && /^## / { exit }
    in_section { print }
  ' "$report_path"
}

first_non_empty_line="$(awk 'NF { print; exit }' "$report_path")"
if [[ ! "${first_non_empty_line}" =~ ^#\ .+\ Derived\ User\ Stories$ ]]; then
  fail "First non-empty line must be '# {actual project name} Derived User Stories'"
fi

prev_line=0
for section in "${required_sections[@]}"; do
  line="$(grep -n -m1 "^## ${section}$" "$report_path" | cut -d: -f1 || true)"
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

story_count=0
while IFS=$'\t' read -r story_id story_text; do
  [[ -n "${story_id}" ]] || continue
  story_count=$((story_count + 1))

  if ! bash "${story_validator}" "${story_text}" >/dev/null; then
    fail "Invalid user story for ${story_id}: ${story_text}"
  fi
done < <(
  awk '
    /^#### Story / {
      story_id = $0
      while (getline > 0) {
        if ($0 ~ /^[[:space:]]*$/) {
          continue
        }
        print story_id "\t" $0
        break
      }
    }
  ' "$report_path"
)

if (( story_count == 0 )); then
  fail "Epic Map requires at least one story"
fi

epic_map_block="$(section_block "Epic Map")"
if ! printf "%s\n" "${epic_map_block}" | grep -Eq '^### Epic: .+'; then
  fail "Epic Map requires at least one epic heading"
fi

if ! grep -Eq '^- Confidence: (High|Medium|Low)$' "$report_path"; then
  fail "Each story must include a confidence label"
fi

if ! grep -Eq '^- Rationale: .+' "$report_path"; then
  fail "Each story must include a rationale"
fi

if ! grep -Eq '^- Code Evidence:$' "$report_path"; then
  fail "Each story must include a Code Evidence block"
fi

if ! grep -Eq '^- Test Evidence:$' "$report_path"; then
  fail "Each story must include a Test Evidence block"
fi

if has_unresolved_template_placeholders; then
  fail "Report still contains unresolved template placeholders ([TODO: ...] or legacy <...> tokens)"
fi

if (( errors > 0 )); then
  echo
  echo "Validation failed with ${errors} error(s)."
  exit 1
fi

echo "Validation passed."
