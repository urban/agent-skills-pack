---
name: derive-requirements
description: Reconstruct requirements artifacts from repository evidence and reconstructed user-visible behavior. Use when a user needs implemented product obligations documented for an existing system.
metadata:
  version: 0.2.0
  layer: specialist
  archetype: research
  domain: specification-reconstruction
  dependencies:
    - write-requirements
---

## Rules

- Treat repository code and tests as the primary evidence because this role documents implemented reality, not remembered intent.
- Produce the artifact as `requirements.md`.
- Use the `write-requirements` contract so the derived artifact stays compatible with authored requirements.
- Prefer user-visible behavior and explicit constraints over internal plumbing because the output is still a requirements artifact.
- Keep evidence traceable to concrete file paths and line references when support is thin or disputed.
- Use context from `./charter.md` and `./user-stories.md` when they exist because reconstructed requirements should stay aligned to reconstructed framing and outcomes.
- Use `TODO: Confirm` when the repository cannot prove the actor, rationale, intended scope boundary, or verification expectation.
- Do not define workflow-wide `source_artifacts` lineage policy here.

## Constraints

- Output must be one Markdown artifact named `requirements.md`.
- The artifact must stay compatible with the `write-requirements` contract.
- If the destination file already exists, create a timestamped backup before overwrite.
- Do not claim original product framing that is not supported by repository evidence.
- Do not turn technical plumbing into fake user-facing requirements just to fill sections.
- Derive requirements from the reconstructed five-field user-story contract rather than from old sentence-only story assumptions.

## Requirements

Inputs:

- repository source code
- repository tests when present
- optional user-provided scope paths
- optional user-provided output destination

Output:

- one derived requirements artifact named `requirements.md`

In scope:

- reconstructing implemented requirements, constraints, and dependencies
- preserving explicit uncertainty where business rationale cannot be proved
- backing up an existing report before overwrite
- aligning requirements to reconstructed story behavior when `./user-stories.md` is available

Out of scope:

- reconstructing unsupported goals, non-goals, personas, or success criteria as facts
- rewriting the system to match cleaner imagined intent
- producing technical design or execution tasks
- using commit history, PR text, or external docs as primary evidence

## Workflow

1. Confirm analysis scope, defaulting to the full repository when the user does not narrow it.
2. Inventory user-visible behaviors, interfaces, constraints, and dependencies from code and tests.
3. Use reconstructed stories from `./user-stories.md` when available to preserve behavioral traceability.
4. Infer missing rationale only as far as the evidence supports and mark weak points as `TODO: Confirm`.
5. Draft the chosen destination with the `write-requirements` contract.
6. Translate reconstructed story behavior into requirements:
   - use `Actor` and `Action` to identify the implemented obligation
   - use `Situation` to capture preconditions and edge conditions supported by the code
   - use `Outcome` to preserve the visible result
   - use `Observation` to preserve how the implemented behavior can be checked
7. Write `requirements.md` to the chosen destination.
8. If the destination artifact already exists, create a timestamped backup in the same directory before overwrite.
9. Add evidence-aware `TODO: Confirm` markers anywhere actor intent, benefit, scope rationale, or verification framing remains unprovable.
10. Validate with `bash ../write-requirements/scripts/validate_requirements.sh <resolved-requirements-path>`.
11. Deliver the artifact as reconstructed implemented requirements, not as speculative product history.

## Gotchas

- If you describe what the product probably meant to do instead of what the code proves, the report becomes cleaner than reality and misleads future design work. Stay anchored to implemented behavior.
- If every internal subsystem gets promoted into a requirement, the artifact turns into a technical inventory instead of a product contract. Keep the report user-visible unless a constraint clearly belongs in requirements.
- If you only reconstruct actions and ignore situations or observations, you lose the implementation's boundary behavior and testability. Preserve those signals when evidence exists.
- If weak evidence is omitted entirely, reviewers read silence as certainty. Keep ambiguous items and mark them `TODO: Confirm`.
- If you overwrite an existing research report without a backup, later reviewers lose the ability to compare interpretations across passes. Create the timestamped backup first.
- If tests contradict code paths and you smooth over the mismatch, the artifact hides the most important uncertainty in the repo. Record the implemented evidence and note the ambiguity explicitly.
- If file and line evidence is not traceable, disagreements collapse into opinion instead of inspection. Keep support concrete when confidence is not obvious.

## Deliverables

- `requirements.md`
- a timestamped backup when overwriting an existing artifact
- evidence-based reconstructed requirements with explicit uncertainty handling
- validation passing via the shared requirements validator

## Validation Checklist

- artifact filename is `requirements.md`
- existing artifact backup is created before overwrite when needed
- section order and numbering follow the `write-requirements` contract
- requirements describe implemented behavior rather than guessed original intent
- requirements stay compatible with reconstructed user-story behavior when user stories are available
- unresolved high-impact details are marked `TODO: Confirm`
- validation passes with the shared script

## Deterministic Validation

- `bash ../write-requirements/scripts/validate_requirements.sh <resolved-requirements-path>`
