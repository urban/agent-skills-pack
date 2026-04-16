#!/usr/bin/env python3
from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


STYLE_BY_KIND = {
    "change-summary": "hero",
    "summary": "hero",
    "scope": "elevated",
    "cards": "default",
    "callouts": "elevated",
    "traceability": "default",
    "validator": "elevated",
    "timeline": "default",
    "snapshot": "recessed",
    "fragment": "default",
}

GENERIC_ARTIFACT_PROFILE: dict[str, Any] = {
    "profile_id": "artifact-generic-approval-v1",
    "display_name": "Artifact Approval",
    "subtitle": "Glance-first approval surface with traceable evidence, structured review gates, and final snapshot metadata.",
    "review_type": "artifact",
    "sections": [
        {
            "key": "executive-summary",
            "title": "Executive Summary",
            "kind": "summary",
            "label": "Approval Brief",
            "style": "hero",
            "why": "Lead with the shortest possible approval read before deeper review.",
        },
        {
            "key": "scope",
            "title": "Scope",
            "kind": "scope",
            "label": "Boundary",
            "style": "elevated",
            "why": "Separate settled scope from excluded scope before approval decisions.",
        },
        {
            "key": "decisions-required-for-approval",
            "title": "Decisions Required for Approval",
            "kind": "cards",
            "label": "Decision Gate",
            "style": "default",
            "item_label": "Decision",
            "why": "Make explicit approval calls scannable.",
        },
        {
            "key": "risks-and-tradeoffs",
            "title": "Risks and Tradeoffs",
            "kind": "cards",
            "label": "Risk Review",
            "style": "default",
            "item_label": "Risk",
            "why": "Surface tradeoffs before approval locks in direction.",
        },
        {
            "key": "blockers-and-unresolved-items",
            "title": "Blockers and Unresolved Items",
            "kind": "callouts",
            "label": "Open Issues",
            "style": "elevated",
            "item_label": "Blocker",
            "why": "Keep unresolved items visible so approval is not mistaken for completeness.",
        },
        {
            "key": "traceability-map",
            "title": "Traceability Map",
            "kind": "traceability",
            "label": "Evidence",
            "style": "default",
            "why": "Tie substantive approval claims to exact canonical evidence.",
        },
        {
            "key": "validator-status",
            "title": "Validator Status",
            "kind": "validator",
            "label": "Validation",
            "style": "elevated",
            "why": "Show both canonical and approval-view validation status.",
        },
        {
            "key": "downstream-impact-if-approved",
            "title": "Downstream Impact if Approved",
            "kind": "timeline",
            "label": "Impact",
            "style": "default",
            "item_label": "Impact",
            "why": "Clarify what approval enables next.",
        },
        {
            "key": "snapshot-identity",
            "title": "Snapshot Identity",
            "kind": "snapshot",
            "label": "Snapshot",
            "style": "recessed",
            "why": "End with exact snapshot identity and provenance fields.",
        },
    ],
    "glance_cards": [
        {
            "label": "Decisions",
            "section_title": "Decisions Required for Approval",
            "metric": "groups",
            "hint": "Approval calls requiring an explicit yes/no.",
            "tone": "accent",
        },
        {
            "label": "Risks",
            "section_title": "Risks and Tradeoffs",
            "metric": "groups",
            "hint": "Tradeoffs or material concerns to scan fast.",
            "tone": "muted",
        },
        {
            "label": "Open issues",
            "section_title": "Blockers and Unresolved Items",
            "metric": "groups",
            "hint": "Open items that can stall or limit approval.",
            "tone": "warning",
        },
        {
            "label": "Evidence claims",
            "metric": "traceability_claims",
            "hint": "Trace-linked claims backed by verbatim source quotes.",
            "tone": "info",
        },
        {
            "label": "Validator checks",
            "metric": "validator_checks",
            "hint": "Recorded validator passes carried from the review inputs.",
            "tone": "success",
        },
        {
            "label": "Visuals",
            "metric": "visuals",
            "hint": "Carried-forward visual evidence sections in this review.",
            "tone": "info",
        },
    ],
}

PACK_PROFILE: dict[str, Any] = {
    "profile_id": "pack-generic-approval-v1",
    "display_name": "Pack Approval",
    "subtitle": "Glance-first pack review with cross-artifact evidence, shared decision gates, and final pack snapshot metadata.",
    "review_type": "pack",
    "sections": [
        {
            "key": "executive-summary",
            "title": "Executive Summary",
            "kind": "summary",
            "label": "Approval Brief",
            "style": "hero",
            "why": "Lead with the pack-level approval read before detailed review.",
        },
        {
            "key": "scope",
            "title": "Scope",
            "kind": "scope",
            "label": "Boundary",
            "style": "elevated",
            "why": "Show what this pack review covers and excludes.",
        },
        {
            "key": "decisions-required-for-approval",
            "title": "Decisions Required for Approval",
            "kind": "cards",
            "label": "Decision Gate",
            "style": "default",
            "item_label": "Decision",
            "why": "Keep cross-artifact approval calls explicit.",
        },
        {
            "key": "risks-and-tradeoffs",
            "title": "Risks and Tradeoffs",
            "kind": "cards",
            "label": "Risk Review",
            "style": "default",
            "item_label": "Risk",
            "why": "Surface pack-level risks and tradeoffs.",
        },
        {
            "key": "blockers-and-unresolved-items",
            "title": "Blockers and Unresolved Items",
            "kind": "callouts",
            "label": "Open Issues",
            "style": "elevated",
            "item_label": "Blocker",
            "why": "Keep unresolved pack items visible.",
        },
        {
            "key": "traceability-map",
            "title": "Traceability Map",
            "kind": "traceability",
            "label": "Evidence",
            "style": "default",
            "why": "Tie pack claims to exact artifact evidence.",
        },
        {
            "key": "validator-status",
            "title": "Validator Status",
            "kind": "validator",
            "label": "Validation",
            "style": "elevated",
            "why": "Show pack validator results clearly.",
        },
        {
            "key": "downstream-impact-if-approved",
            "title": "Downstream Impact if Approved",
            "kind": "timeline",
            "label": "Impact",
            "style": "default",
            "item_label": "Impact",
            "why": "Clarify what pack approval enables next.",
        },
        {
            "key": "snapshot-identity",
            "title": "Snapshot Identity",
            "kind": "snapshot",
            "label": "Snapshot",
            "style": "recessed",
            "why": "End with exact pack snapshot identity.",
        },
    ],
    "glance_cards": [
        {
            "label": "Decisions",
            "section_title": "Decisions Required for Approval",
            "metric": "groups",
            "hint": "Pack-level approval calls.",
            "tone": "accent",
        },
        {
            "label": "Risks",
            "section_title": "Risks and Tradeoffs",
            "metric": "groups",
            "hint": "Cross-artifact tradeoffs or concerns.",
            "tone": "muted",
        },
        {
            "label": "Open issues",
            "section_title": "Blockers and Unresolved Items",
            "metric": "groups",
            "hint": "Pack gaps or unresolved follow-on work.",
            "tone": "warning",
        },
        {
            "label": "Evidence claims",
            "metric": "traceability_claims",
            "hint": "Pack claims backed by verbatim artifact quotes.",
            "tone": "info",
        },
        {
            "label": "Validator checks",
            "metric": "validator_checks",
            "hint": "Validator passes recorded for this review.",
            "tone": "success",
        },
        {
            "label": "Visuals",
            "metric": "visuals",
            "hint": "Visual evidence carried into the pack review.",
            "tone": "info",
        },
    ],
}

CHANGE_SUMMARY_SECTION: dict[str, Any] = {
    "key": "change-summary",
    "title": "Change Summary",
    "kind": "change-summary",
    "label": "Revision Delta",
    "style": "hero",
    "item_label": "Delta",
    "why": "Lead revised approvals with exact deltas from the last approved snapshot.",
}

FALLBACK_SKILL_BY_BASENAME = {
    "charter.md": "charter",
    "user-stories.md": "user-story-authoring",
    "requirements.md": "requirements",
    "technical-design.md": "technical-design",
    "execution-plan.md": "execution-planning",
    "execution-tasks.md": "task-generation",
}


def _search_repo_root(start: Path) -> Path | None:
    start = start.resolve()
    anchor = start if start.is_dir() else start.parent
    for candidate in [anchor, *anchor.parents]:
        if (candidate / ".agents" / "skills").is_dir():
            return candidate
    return None


def repo_root(hint: Path | None = None) -> Path:
    candidates: list[Path] = []
    if hint is not None:
        candidates.append(hint)
    candidates.append(Path.cwd())
    candidates.append(Path(__file__).resolve())

    for candidate in candidates:
        resolved = _search_repo_root(candidate)
        if resolved is not None:
            return resolved

    return Path.cwd().resolve()


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def slugify(value: str) -> str:
    slug = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return slug or "section"


def _normalize_section(section: dict[str, Any]) -> dict[str, Any]:
    title = str(section["title"]).strip()
    kind = str(section.get("kind", "fragment")).strip()
    key = str(section.get("key") or slugify(title)).strip()
    style = str(section.get("style") or STYLE_BY_KIND.get(kind, "default")).strip()
    normalized = {
        "key": key,
        "title": title,
        "kind": kind,
        "label": str(section.get("label") or title).strip(),
        "style": style,
        "item_label": str(section.get("item_label") or "Item").strip(),
        "empty_state": str(section.get("empty_state") or "None").strip(),
        "why": str(section.get("why") or "").strip(),
    }
    if "glance" in section:
        normalized["glance"] = section["glance"]
    return normalized


def normalize_profile(raw_profile: dict[str, Any], source: str) -> dict[str, Any]:
    sections = [_normalize_section(section) for section in raw_profile.get("sections", [])]
    if not sections:
        raise ValueError(f"Approval profile has no sections: {source}")

    seen_titles: set[str] = set()
    seen_keys: set[str] = set()
    kinds = [section["kind"] for section in sections]
    for section in sections:
        if section["title"] in seen_titles:
            raise ValueError(f"Duplicate approval profile section title '{section['title']}' in {source}")
        if section["key"] in seen_keys:
            raise ValueError(f"Duplicate approval profile section key '{section['key']}' in {source}")
        seen_titles.add(section["title"])
        seen_keys.add(section["key"])

    if kinds.count("traceability") != 1:
        raise ValueError(f"Approval profile must define exactly one traceability section: {source}")
    if kinds.count("validator") != 1:
        raise ValueError(f"Approval profile must define exactly one validator section: {source}")
    if kinds.count("snapshot") != 1:
        raise ValueError(f"Approval profile must define exactly one snapshot section: {source}")
    if sections[-1]["kind"] != "snapshot":
        raise ValueError(f"Approval profile snapshot section must be final: {source}")

    glance_cards = list(raw_profile.get("glance_cards", []))
    return {
        "profile_id": str(raw_profile.get("profile_id") or slugify(str(source))),
        "display_name": str(raw_profile.get("display_name") or "Approval View").strip(),
        "subtitle": str(raw_profile.get("subtitle") or GENERIC_ARTIFACT_PROFILE["subtitle"]).strip(),
        "review_type": str(raw_profile.get("review_type") or "artifact").strip(),
        "sections": sections,
        "glance_cards": glance_cards,
        "source": source,
        "default_visual_section": raw_profile.get("default_visual_section"),
    }


def frontmatter_lines(markdown_text: str) -> list[str]:
    lines = markdown_text.splitlines()
    if not lines or lines[0].strip() != "---":
        return []
    collected: list[str] = []
    for line in lines[1:]:
        if line.strip() == "---":
            return collected
        collected.append(line)
    return []


def parse_producing_skill(markdown_text: str) -> str | None:
    lines = frontmatter_lines(markdown_text)
    if not lines:
        return None

    in_generated_by = False
    for line in lines:
        if line.strip() == "generated_by:":
            in_generated_by = True
            continue
        if in_generated_by:
            if re.match(r"^[^\s#-]", line):
                break
            match = re.match(r"^\s{2}producing_skill:\s*(.+)$", line)
            if match:
                return match.group(1).strip()
    return None


def profile_path_for_skill(skill_name: str, root: Path | None = None) -> Path:
    return repo_root(root) / ".agents" / "skills" / skill_name / "assets" / "approval-view-profile.json"


def load_profile_file(path: Path) -> dict[str, Any]:
    data = json.loads(read_text(path))
    return normalize_profile(data, str(path.resolve()))


def _artifact_profile_candidates(canonical_path: Path, canonical_text: str | None) -> list[Path]:
    candidates: list[Path] = []
    root = repo_root(canonical_path)
    producing_skill = parse_producing_skill(canonical_text or "") if canonical_text is not None else None
    if producing_skill:
        candidates.append(profile_path_for_skill(producing_skill, root))
    fallback_skill = FALLBACK_SKILL_BY_BASENAME.get(canonical_path.name)
    if fallback_skill:
        fallback_path = profile_path_for_skill(fallback_skill, root)
        if fallback_path not in candidates:
            candidates.append(fallback_path)
    return candidates


def load_artifact_profile(canonical_path: Path) -> dict[str, Any]:
    canonical_path = canonical_path.resolve()
    canonical_text = read_text(canonical_path) if canonical_path.is_file() else None
    for candidate in _artifact_profile_candidates(canonical_path, canonical_text):
        if candidate.is_file():
            return load_profile_file(candidate)
    return normalize_profile(GENERIC_ARTIFACT_PROFILE, "built-in artifact fallback")


def load_pack_profile() -> dict[str, Any]:
    return normalize_profile(PACK_PROFILE, "built-in pack fallback")


def load_review_profile(review_type: str, canonical_path: Path | None = None) -> dict[str, Any]:
    if review_type == "artifact":
        if canonical_path is None:
            return normalize_profile(GENERIC_ARTIFACT_PROFILE, "built-in artifact fallback")
        return load_artifact_profile(canonical_path)
    if review_type == "pack":
        return load_pack_profile()
    raise ValueError(f"Unsupported review type: {review_type}")


def section_specs(profile: dict[str, Any], revised: bool) -> list[dict[str, Any]]:
    specs = list(profile["sections"])
    if revised:
        return [dict(CHANGE_SUMMARY_SECTION)] + [dict(spec) for spec in specs]
    return [dict(spec) for spec in specs]


def section_spec_by_title(profile: dict[str, Any], revised: bool) -> dict[str, dict[str, Any]]:
    return {spec["title"]: spec for spec in section_specs(profile, revised)}


def section_spec_by_kind(profile: dict[str, Any], revised: bool) -> dict[str, dict[str, Any]]:
    return {spec["kind"]: spec for spec in section_specs(profile, revised)}
