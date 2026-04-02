# Skill Structure

Use this document when creating or updating a skill directory in this package.

## Required Layout

The canonical package layout is:

- `skills/<skill-name>/`

Every package skill lives under `skills/`. Use `metadata.layer` to declare whether it is foundational, expertise, or orchestration.

Choose one layer only:

- foundational for reusable contracts, templates, validators, naming rules, and provenance-and-traceability rules
- expertise for one expertise-specific entry skill that applies foundational contracts
- orchestration for a coordinating skill that depends on expertise skills only

Each skill lives in its own directory:

- `skills/<skill-name>/SKILL.md`

Add these only when needed:

- `skills/<skill-name>/assets/`
- `skills/<skill-name>/scripts/`
- `skills/<skill-name>/references/`

Use:

- `assets/` for templates, regexes, or scaffolds the skill directly uses
- `scripts/` for deterministic validators or helper scripts
- `references/` for short guidance docs the skill should consult on demand

## Required Frontmatter

Every `SKILL.md` must define:

- `name`
- `description`
- `metadata.layer`

Add `metadata.dependencies` when the skill composes other skills or relies on shared contracts.

If a skill creates or validates a skill-pack artifact, prefer an explicit dependency on `document-traceability` unless the skill is purely orchestration-level and delegates provenance stamping to lower-layer skills.

Add `metadata.archetype` and `metadata.domain` only for expertise skills.

Example:

```yaml
---
name: example-skill
description: One-sentence description of the reusable workflow this skill owns.
metadata:
  layer: foundational
  dependencies:
    - write-requirements
    - artifact-naming
---
```

## Dependency Direction Rules

- foundational skills must not depend on other skills
- expertise skills may depend only on foundational skills
- orchestration skills may depend only on expertise skills

## Validation Expectations

If you add or change a skill:

- verify the `SKILL.md` is internally consistent
- verify every linked asset, script, or reference path exists
- run any deterministic validator scripts you introduce
- verify created artifacts use canonical provenance and the correct `source_artifacts` roles when the skill emits skill-pack artifacts
- keep examples and output paths aligned with package terminology
