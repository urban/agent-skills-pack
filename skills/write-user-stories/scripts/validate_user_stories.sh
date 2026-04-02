#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: validate_user_stories.sh <user-stories-file>" >&2
  exit 1
fi

FILE="$1"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PATTERN_FILE="$SCRIPT_DIR/../assets/story-pattern.regex"
PROVENANCE_SCRIPT="$SCRIPT_DIR/../../document-traceability/scripts/validate_frontmatter_provenance.sh"

if [[ ! -f "$FILE" ]]; then
  echo "User stories file not found: $FILE" >&2
  exit 1
fi

bash "$PROVENANCE_SCRIPT" user-stories "$FILE"

story_pattern="$(tr -d '\n' < "$PATTERN_FILE")"

mapfile -t story_lines < <(grep -E '^[[:space:]]*[0-9]+\.[[:space:]]+As an? .+, I want .+, so that .+\.$' "$FILE" || true)
if (( ${#story_lines[@]} == 0 )); then
  echo "User stories artifact must include at least one numbered canonical story sentence" >&2
  exit 1
fi

while IFS= read -r line; do
  story="$(printf '%s\n' "$line" | sed -E 's/^[[:space:]]*[0-9]+\.[[:space:]]+//')"
  if [[ ! "$story" =~ $story_pattern ]]; then
    echo "Invalid story sentence: $story" >&2
    exit 1
  fi
done < <(printf '%s\n' "${story_lines[@]}")

echo "User stories validation passed: $FILE"
