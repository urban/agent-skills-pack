# Skill authoring guide

Use this guide when creating or updating a skill.

## Canonical layout

Every skill lives under:

- `skills/<skill-name>/`

Every skill must include:

- `skills/<skill-name>/SKILL.md`

Add these only when needed:

- `skills/<skill-name>/assets/`
- `skills/<skill-name>/scripts/`
- `skills/<skill-name>/references/`

Use them like this:

| Path | Use for |
| --- | --- |
| `assets/` | templates, regexes, scaffolds |
| `scripts/` | deterministic validators or helpers |
| `references/` | short optional guidance or routing help |

## Required `SKILL.md` frontmatter

Every `SKILL.md` must define:

- `name`
- `description`
- `metadata.layer`

Add `metadata.dependencies` when the skill composes other skills or relies on shared contracts.

Specialist skills must also define:

- `metadata.archetype`
- `metadata.domain`

If a skill creates or validates a package artifact, prefer an explicit dependency on `document-traceability` unless a lower-layer contract already handles provenance.

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

- **foundational** — reusable leaf contracts, templates, validators, naming, metadata, provenance mechanics
- **specialist** — one bounded leaf skill built on foundational contracts that produces one artifact or bounded analysis/planning output
- **coordination** — workflow-wide coordination across specialist skills

Dependency direction is strict:

- foundational must not depend on other skills
- specialist may depend only on foundational skills
- coordination must depend on specialist skills for artifact-producing work
- coordination may also use selected foundational leaf contracts only for workflow-wide coordination concerns such as naming, spec-pack root selection, or provenance assembly support
- coordination must not use foundational dependencies to replace specialist artifact contracts

## Path and filename ownership

Treat location as three separate concerns.

| Concern | Owner | Example |
| --- | --- | --- |
| artifact basename | foundational | `<project-name>` |
| spec-pack root | coordination | `.specs/<project-name>/` |
| artifact filename | specialist | `requirements.md` |

Use that split when writing skill instructions.

### Practical rules

- foundational skills may define naming rules, metadata shape, validators, templates, and provenance assembly mechanics
- coordination skills may choose or override one spec-pack root for a run
- specialist skills should define the filename of the artifact they produce
- when specialist skills refer to sibling artifacts in the same pack, use pack-relative paths such as `./charter.md`
- specialist skills may describe same-pack context and local validation commands, but should not define workflow-level lineage policy or hardcode root workflow identity
- validators may operate on fully resolved runtime paths, but the skill contract should describe pack-local placement when that is the real contract

## Progressive disclosure

Write documentation so an agent can load only what it needs.

Use these layers:

| File | Put this there |
| --- | --- |
| `AGENTS.md` | package-wide invariants, routing, non-negotiable boundaries |
| `SKILL.md` | what the agent must do when that skill is selected |
| `docs/`, `references/`, `assets/`, `scripts/` | optional detail, templates, validators, and deeper maintenance guidance |

### Good defaults

Put this in `AGENTS.md`:

- package-wide rules
- the layer model
- links to the canonical docs

Put this in `SKILL.md`:

- purpose
- workflow
- constraints
- required deliverables
- validation steps
- links to deeper resources when needed

Put this in support files:

- situational detail
- long explanations
- shared maintenance guidance
- templates and validators

### Avoid

- putting every rule in `AGENTS.md`
- turning `SKILL.md` into a maintenance dump
- duplicating the same rule across files
- vague links that do not say when to read them

Give each rule one home, then link to it.

## Writing guidance for humans and agents

Prefer:

- deterministic filenames
- explicit headings
- concise instructions
- direct workflow order
- local validation commands
- explicit uncertainty instead of guessed intent

Avoid:

- vague prose
- hidden assumptions
- repeated copies of the same contract
- path guidance that mixes basename, root, and filename ownership

## Validation checklist for authors

When you add or change a skill:

- verify `SKILL.md` is internally consistent
- verify linked assets, scripts, and references exist
- run any validator scripts you add
- verify emitted artifacts use canonical provenance and the correct `source_artifacts` keys
- keep examples and output paths aligned with package terminology and layer ownership
