#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path

from approval_profiles import load_review_profile, section_specs


USAGE = """Usage:
  scaffold_approval_view.py artifact <canonical-file>
  scaffold_approval_view.py artifact-revised <canonical-file>
  scaffold_approval_view.py pack
  scaffold_approval_view.py pack-revised
"""


def section_template(spec: dict[str, str], mode: str, review_type: str) -> str:
    title = spec["title"]
    kind = spec["kind"]
    item_label = spec.get("item_label", "Item")
    empty_state = spec.get("empty_state", "None")

    if kind == "change-summary":
        return f"## {title}\n\n- Previous snapshot SHA-256: [TODO: previous approved snapshot hash]\n- [TODO: one delta per bullet; use `- None` only when no substantive change exists]"

    if kind == "summary":
        return (
            f"## {title}\n\n"
            "- [TODO: 1-3 concise bullets aligned to this artifact's approval focus]\n\n"
            "### Visual Evidence\n\n"
            "- [TODO: copy in-scope Mermaid or other visual sections here when material; delete this subsection if none are in scope]"
        )

    if kind == "scope":
        return (
            f"## {title}\n\n"
            "- In scope:\n"
            "  - [TODO: what this review settles]\n"
            "- Out of scope:\n"
            "  - [TODO: what this review does not settle]"
        )

    if kind == "cards":
        return f"## {title}\n\n- [TODO: one {item_label.lower()} per bullet; start with the reviewable point]"

    if kind == "callouts":
        return f"## {title}\n\n- [TODO: one {item_label.lower()} or unresolved item per bullet; use `- {empty_state}` when clear]"

    if kind == "timeline":
        return f"## {title}\n\n- [TODO: one {item_label.lower()} per bullet; order by sequence, dependency, or impact]"

    if kind == "traceability":
        return (
            f"## {title}\n\n"
            "- [T1] Claim: [TODO: substantive claim]\n"
            "  - Source: [TODO: resolved canonical path] :: [TODO: exact heading]\n"
            '  - Evidence quote: "[TODO: verbatim quote from the canonical section]"'
        )

    if kind == "validator":
        approval_command = "bash ./scripts/validate_approval_view.sh"
        if review_type == "artifact":
            approval_command = f"{approval_command} {mode} <canonical-file> <approval-md> <approval-html>"
        else:
            approval_command = f"{approval_command} {mode} <approval-md> <approval-html> <canonical-file>..."
        return (
            f"## {title}\n\n"
            "- Canonical validator:\n"
            "  - Command: [TODO: canonical validator command]\n"
            "  - Result: Passed\n"
            "- Approval-view validator:\n"
            f"  - Command: [TODO: {approval_command}]\n"
            "  - Result: Passed"
        )

    if kind == "snapshot":
        if review_type == "artifact":
            approval_mode = "Revised" if mode == "artifact-revised" else "Initial"
            return (
                f"## {title}\n\n"
                "- Review type: Artifact\n"
                f"- Approval mode: {approval_mode}\n"
                "- Canonical artifact: [TODO: resolved canonical path]\n"
                "- Snapshot SHA-256: [TODO: SHA-256 of canonical artifact bytes]\n"
                "- Canonical updated_at: [TODO: updated_at from canonical frontmatter]\n"
                "- Approval view generated_at: [TODO: UTC ISO 8601 timestamp]"
            )
        approval_mode = "Revised" if mode == "pack-revised" else "Initial"
        return (
            f"## {title}\n\n"
            "- Review type: Pack\n"
            f"- Approval mode: {approval_mode}\n"
            "- Spec-pack root: [TODO: resolved spec-pack root]\n"
            "- Pack snapshot SHA-256: [TODO: aggregate SHA-256 of sorted path + file-hash pairs]\n"
            "- Approval view generated_at: [TODO: UTC ISO 8601 timestamp]\n"
            "- Included snapshots:\n"
            "  - [TODO: resolved canonical path] | SHA-256: [TODO: file hash] | updated_at: [TODO: updated_at]"
        )

    return f"## {title}\n\n- [TODO: fill this section from the canonical artifact only]"


def main() -> int:
    if len(sys.argv) not in {2, 3}:
        print(USAGE, file=sys.stderr)
        return 1

    mode = sys.argv[1]
    if mode not in {"artifact", "artifact-revised", "pack", "pack-revised"}:
        print(USAGE, file=sys.stderr)
        return 1

    if mode.startswith("artifact") and len(sys.argv) != 3:
        print(USAGE, file=sys.stderr)
        return 1
    if mode.startswith("pack") and len(sys.argv) != 2:
        print(USAGE, file=sys.stderr)
        return 1

    review_type = "artifact" if mode.startswith("artifact") else "pack"
    revised = mode.endswith("revised")
    canonical_path = Path(sys.argv[2]).resolve() if review_type == "artifact" else None
    profile = load_review_profile(review_type, canonical_path)

    lines = ["# Approval View", ""]
    for index, spec in enumerate(section_specs(profile, revised)):
        if index > 0:
            lines.append("")
        lines.append(section_template(spec, mode, review_type))

    print("\n".join(lines))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
