# Skill structure

Use this guide when creating or updating a skill.

## Canonical layout

Every skill lives under:

- `skills/<skill-name>/`

Each skill must include:

- `skills/<skill-name>/SKILL.md`

Add these only when needed:

- `skills/<skill-name>/assets/`
- `skills/<skill-name>/scripts/`
- `skills/<skill-name>/references/`

Use them like this:

- `assets/` — templates, regexes, scaffolds
- `scripts/` — deterministic validators or helpers
- `references/` — short optional guidance

## Required frontmatter

Every `SKILL.md` must define:

- `name`
- `description`
- `metadata.layer`

Add `metadata.dependencies` when the skill composes other skills or relies on shared contracts.

Expertise skills must also define:

- `metadata.archetype`
- `metadata.domain`

If a skill creates or validates a package artifact, prefer an explicit dependency on `document-traceability` unless a lower-layer skill handles provenance.

Example:

```yaml
---
name: example-skill
description: One-sentence description of the workflow this skill owns.
metadata:
  layer: foundational
  dependencies:
    - write-requirements
    - artifact-naming
---
```

## Layer rules

Choose exactly one layer:

- **foundational** — reusable contracts, templates, validators, naming, provenance
- **expertise** — one bounded skill built on foundational contracts
- **orchestration** — a coordinating skill that depends on expertise skills only

Dependency direction is strict:

- foundational must not depend on other skills
- expertise may depend only on foundational skills
- orchestration may depend only on expertise skills

## Validation checklist

When you add or change a skill:

- verify `SKILL.md` is internally consistent
- verify linked assets, scripts, and references exist
- run any validator scripts you add
- verify emitted artifacts use canonical provenance and the correct `source_artifacts` roles
- keep examples and output paths aligned with package terminology
