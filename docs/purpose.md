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

- **foundational** — shared contracts, templates, validators, naming, provenance
- **expertise** — one bounded authoring, reconstruction, design, or planning job
- **orchestration** — multi-step flows across expertise skills

Each skill declares its layer in `metadata.layer`.

Within that split:

- foundational naming resolves stable artifact basenames such as `<project-name>`
- orchestration coordinates spec-pack root placement for a workflow and may use selected foundational leaf contracts for workflow-wide concerns such as naming
- expertise produces artifact-specific outputs within that spec pack

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
