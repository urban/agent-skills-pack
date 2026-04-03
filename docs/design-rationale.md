# Design rationale

This pack is contract-first because the same artifact shapes must work across authoring, reconstruction, and planning.

## Why the pack is layered

Each layer has one job:

- **foundational** — reusable contracts, templates, validators, naming rules
- **expertise** — one bounded application of those contracts
- **orchestration** — coordination across expertise skills

Every skill still lives under `skills/<skill-name>/` and declares its layer in `metadata.layer`.

This keeps dependencies simple and avoids duplicated contract logic.

## Why shared contracts matter

Authored and reconstructed artifacts should stay compatible when they represent the same artifact type.

That is why both paths reuse the same foundational contracts for charter, user stories, requirements, technical design, execution plans, and task tracking.

If those contracts drift, reconstructed artifacts stop being reliable inputs.

## Why authoring, reconstruction, and planning stay separate

These workflows start from different sources of truth:

- **authoring** — product intent and approved scope
- **reconstruction** — repository evidence and implemented behavior
- **planning** — approved specification artifacts

If one skill mixes them, it becomes unclear whether an artifact describes intent, reality, or sequencing.

## Why execution coordination is downstream

Execution plans and task tracking are coordination artifacts, not substitutes for requirements or technical design.

Keeping them downstream prevents:

- planning from redefining scope
- task generation from becoming issue-tracker boilerplate
- technical design from collapsing into sequencing notes

## Why execution state is local

Plans and tasks live in the repo so they stay:

- close to the code
- easy to review
- reloadable by agents
- usable without external tooling
