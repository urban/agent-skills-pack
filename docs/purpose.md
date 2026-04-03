# Purpose

`agent-skills-pack` makes software specification artifacts usable in both directions:

- from product intent to implementation
- from an implemented system back to reusable specification artifacts

## What the pack owns

The pack covers skills for:

- charter
- user stories
- requirements
- technical design
- execution plan
- task tracking

Skills live under `skills/` and fit one layer:

- **foundational** — reusable leaf contracts, templates, validators, naming, provenance
- **expertise** — one bounded leaf authoring, reconstruction, design, or planning job
- **orchestration** — workflow-wide flows across expertise skills

Each skill declares its layer in `metadata.layer`.

Within that split:

- foundational owns reusable leaf contracts such as naming, metadata shape, validators, templates, provenance assembly mechanics, and generic field semantics
- expertise owns one bounded artifact or one bounded analysis or planning output, including the artifact filename and local same-pack context it needs
- orchestration owns workflow-wide coordination such as `<project-name>` resolution for a run, spec-pack root selection, output defaults or overrides, staged flow, root workflow provenance, canonical lineage expectations, and cross-artifact consistency

This keeps child skills from knowing parent workflow framing and keeps workflow placement and lineage policy out of lower layers.

## Why it matters

Without stable artifacts, agents infer too much from prompts and repository clues. That leads to:

- scope drift
- architecture drift
- weak traceability
- weaker follow-on work

This pack reduces that ambiguity by making contracts, provenance, and lineage explicit.

## Core guarantee

Provenance and source-artifact lineage are part of the artifact contract.

Each created artifact should show:

- how it was produced
- which upstream artifacts shaped it
- where uncertainty remains
