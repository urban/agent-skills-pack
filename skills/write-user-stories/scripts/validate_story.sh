#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pattern_file="${script_dir}/../assets/story-pattern.regex"

if [[ ! -f "${pattern_file}" ]]; then
  echo "Error: story pattern not found: ${pattern_file}"
  exit 1
fi

pattern="$(tr -d '\r\n' < "${pattern_file}")"
story_input="${1:-}"

if [[ -z "${story_input}" && ! -t 0 ]]; then
  story_input="$(cat)"
fi

story="$(printf '%s' "${story_input}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

if [[ -z "${story}" ]]; then
  echo "Usage: scripts/validate_story.sh '<story>'"
  exit 1
fi

if printf '%s\n' "${story}" | grep -Eq '\[TODO:[^]]+\]|<[^>]+>'; then
  echo "Error: story contains unresolved placeholder tokens"
  exit 1
fi

if ! printf '%s\n' "${story}" | grep -Eq "^${pattern}$"; then
  echo "Error: story does not match canonical user-story contract"
  exit 1
fi

echo "Story validation passed."
