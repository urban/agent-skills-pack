---
name: requirements
description: Produce implementation-ready requirements artifacts from an approved charter, user stories, and repository evidence. Use when a user wants product obligations, constraints, and dependencies defined before design or coding.
metadata:
  version: 0.1.0
  layer: specialist
  archetype: planning
  domain: specification-authoring
  dependencies:
    - document-traceability
    - write-requirements
---

## Rules

- Keep this role focused on producing the requirements artifact because charter-defined scope, architecture, and execution planning belong in adjacent artifacts.
- Produce the artifact as `requirements.md`.
- Use `document-traceability` to stamp canonical provenance plus `source_artifacts.charter` and `source_artifacts.user_stories` because requirements depend on both upstream artifacts.
- Use the `write-requirements` contract for section order, numbering, uncertainty handling, and final validation because downstream design and planning depend on that shared shape.
- Ground requirements in approved user stories first, then repository evidence when existing code or integrations constrain behavior.
- Keep approved charter context visible from `./charter.md` because requirements must stay inside its goals, actors, and success boundaries without re-owning them.
- Use approved story context from `./user-stories.md` because requirements should trace back to user-visible outcomes.
- Ask for clarification when missing detail changes scope, constraints, integrations, dependencies, or verifiability; otherwise keep moving and mark `TODO: Confirm`.

## Constraints

- Output must be one Markdown artifact named `requirements.md`.
- The artifact must stay compatible with the `write-requirements` contract.
- The artifact must record `source_artifacts.charter` and `source_artifacts.user_stories`.
- Do not restate goals, non-goals, personas, or success criteria already owned by the charter except when a short traceability note is required.
- Do not mix implementation strategy, file-level design, or execution sequencing into the requirements artifact.
- Keep unresolved high-impact details explicit as `TODO: Confirm` instead of inventing certainty.

## Requirements

Inputs:

- approved charter
- approved user stories
- known constraints, integrations, data rules, and dependencies
- repository evidence when existing behavior affects scope

Output:

- one complete requirements artifact named `requirements.md`

In scope:

- writing numbered functional requirements derived from approved stories
- recording non-functional requirements, constraints, data rules, integrations, and dependencies
- stamping deterministic provenance and source-artifact lineage
- preserving explicit uncertainty markers where needed

Out of scope:

- redefining goals, non-goals, personas, or success criteria already approved upstream
- technical architecture
- implementation task planning
- code changes

## Workflow

1. Confirm the user wants a requirements artifact after approved charter and user stories.
2. Gather the approved charter, approved user stories, constraints, integrations, data rules, dependencies, and success boundaries that the requirements must satisfy from available inputs, `./charter.md`, and `./user-stories.md` when present.
3. Inspect the repository only when existing code, integrations, or platform boundaries materially affect the requirements.
4. Draft `requirements.md` using the `write-requirements` contract rather than inventing a new structure.
5. Stamp canonical provenance with `source_artifacts.charter` and `source_artifacts.user_stories`.
6. Keep requirements externally meaningful and verifiable; move implementation ideas out of the artifact.
7. Keep the artifact on obligations and constraints; push repeated goals, persona summaries, and success-criterion restatements back to the charter unless traceability would be lost.
8. Mark unresolved high-impact details as `TODO: Confirm`.
9. Validate with `bash ../write-requirements/scripts/validate_requirements.sh <resolved-requirements-path>`.
10. Deliver the draft and request approval before downstream design or implementation work.

## Gotchas

- If you treat requirements like a place to solve the system, technical design becomes a rewrite of decisions already smuggled in. Keep the artifact about product obligations and constraints, not architecture.
- If requirements start before the stories are stable, scope leaks in through formal language and later looks approved only because it was written down. Anchor the artifact to approved stories first.
- If you restate goals, non-goals, personas, or success criteria at length, the pack grows redundant and later edits drift across files. Let the charter own framing.
- If you draft from memory instead of the shared `write-requirements` contract, numbering and section order drift and downstream skills stop composing cleanly. Reuse the canonical structure every time.
- If repository evidence already constrains behavior and you ignore it, the requirements read clean but contradict the product the team actually has to evolve. Inspect the code when it materially affects scope.
- If provenance omits either `charter` or `user_stories`, later design and planning cannot prove which approved obligations the artifact inherited. Keep both source artifact-types explicit.
- If missing details are guessed to keep momentum, later design work inherits invented certainty and has to unwind it. Use `TODO: Confirm` for high-impact unknowns.

## Deliverables

- `requirements.md`
- explicit functional requirements, non-functional requirements, technical constraints, data requirements, integration requirements, and dependencies
- deterministic provenance plus `source_artifacts.charter` and `source_artifacts.user_stories`
- validation passing via the shared requirements validator
- a draft ready for user review before technical design or implementation

## Validation Checklist

- artifact filename is `requirements.md`
- section order and numbering follow the `write-requirements` contract
- `source_artifacts.charter` and `source_artifacts.user_stories` are present
- at least one functional requirement exists
- implementation strategy is not mixed into the artifact
- unresolved high-impact details are marked `TODO: Confirm`

## Deterministic Validation

- `bash ../write-requirements/scripts/validate_requirements.sh <resolved-requirements-path>`
