# AGENTS.md

## Purpose

This package contains composable skills for a reversible specification system.

Optimize for:

- reversibility between authored and reconstructed spec packs
- shared artifact contracts in foundational skills
- narrow expertise entry skills
- orchestration separated from expertise and contract logic
- explicit provenance and source-artifact lineage for created artifacts

## Hard rules

- All skills live under `skills/`.
- Every skill declares exactly one layer in `metadata.layer`.
- Expertise skills must also define `metadata.archetype` and `metadata.domain`.
- Keep support files inside the owning skill directory:
  - `assets/` — templates and scaffolds
  - `scripts/` — deterministic validators or helpers
  - `references/` — optional routing or supporting guidance
- Use installed runtime-relative paths inside skills:
  - skill-local: `./assets/...`, `./scripts/...`, `./references/...`
  - cross-skill: `../write-requirements/...`
  - never source-relative paths like `../../skills/...`
- Do not create a new skill for project-specific content or one-off analysis.

## Layer model

- **foundational** — shared contracts, templates, validators, naming, provenance mechanics
- **expertise** — one bounded application of foundational contracts within one role or domain
- **orchestration** — workflow-wide coordination across expertise skills

If a skill crosses layers, split it.

## Package defaults

Prefer:

- shared contracts over duplicated rules
- composition over duplication
- deterministic filenames and validation
- explicit uncertainty over guessed intent
- local references over optional required dependencies

## Read first

- [`docs/README.md`](./docs/README.md)
- [`docs/system-overview.md`](./docs/system-overview.md)
- [`docs/provenance.md`](./docs/provenance.md)
- [`docs/skill-authoring.md`](./docs/skill-authoring.md)

## Read by task

| Task | Read first |
| --- | --- |
| Decide whether to add or split a skill | [`docs/skill-selection.md`](./docs/skill-selection.md) |
| Create or update `SKILL.md` | [`docs/skill-authoring.md`](./docs/skill-authoring.md) |
| Check provenance and lineage | [`docs/provenance.md`](./docs/provenance.md) |
| Review a skill before shipping | [`docs/review-checklist.md`](./docs/review-checklist.md) |

Use [`docs/skill-authoring.md`](./docs/skill-authoring.md) as the canonical source for `skills/` layout, `SKILL.md` requirements, and skill-local file placement.
