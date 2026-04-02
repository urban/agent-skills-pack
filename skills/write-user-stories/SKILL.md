---
name: write-user-stories
description: Write and validate canonical user stories with actor-action-benefit structure. Use when a task creates, derives, reviews, or validates user stories that must stay compatible across requirements, planning, and analysis workflows.
metadata:
  version: 0.1.0
  layer: foundational
  dependencies:
    - document-traceability
---

## Rules

- Express one user-visible outcome per story because bundled outcomes hide scope and acceptance.
- Use the `document-traceability` contract for canonical frontmatter, timestamps, provenance, source-artifact lineage, and shared validation.
- Write each story as one canonical sentence with actor, action, and benefit in that order because downstream tools and reviewers need stable parsing.
- Use `As an` instead of `As a` when grammar requires it.
- Keep actor, action, and benefit concrete and externally observable because stories should describe value, not internal implementation.
- Replace unsupported fields with `TODO: Confirm` instead of guessing.
- Do not write implementation tasks as user stories unless the user directly experiences the outcome.

## Constraints

- Output must be one Markdown artifact.
- Frontmatter must use canonical authored-document fields from `document-traceability`.
- `source_artifacts` must include exactly `charter`.
- Preserve the exact clause order: actor, action, then benefit.
- Use the sentence shape `As a` or `As an` ..., `I want` ..., `so that` ....
- End each story with a period.
- Do not omit the benefit clause.
- Do not infer unsupported intent just to complete a clean sentence.

## Requirements

A valid user-stories artifact must include:

- canonical provenance and timestamp frontmatter
- `source_artifacts.charter`
- at least one canonical user-story sentence
- unresolved actor, action, or benefit fields expressed as `TODO: Confirm` inline when needed

Allowed surrounding structure:

- title
- numbering
- grouping by epic or theme
- evidence notes
- confidence labels
- diagrams that add context without replacing story sentences

That surrounding structure must not redefine or replace the canonical sentence.

Inputs:

- user-visible outcome or source material from which the outcome can be derived
- actor context and benefit rationale when known
- approved charter path for `source_artifacts.charter`

Output:

- one or more canonical user-story sentences that downstream requirements or planning skills can consume directly

## Workflow

1. Draft from [`assets/user-stories-template.md`](./assets/user-stories-template.md) when a full artifact scaffold helps.
2. Stamp canonical frontmatter from `document-traceability`, including `source_artifacts.charter`.
3. Identify one user-visible outcome per story candidate.
4. Use [`assets/story-template.md`](./assets/story-template.md) when a scaffold helps separate actor, action, and benefit before collapsing to one sentence.
5. Name the actor who receives value.
6. State the action in user language rather than implementation language.
7. State the benefit that explains why the action matters.
8. Replace any unsupported field with `TODO: Confirm` rather than inventing intent.
9. Ensure the final sentence uses the canonical pattern and ends with a period.
10. Validate the artifact with [`scripts/validate_user_stories.sh`](./scripts/validate_user_stories.sh) and use [`scripts/validate_story.sh`](./scripts/validate_story.sh) for single-story debugging.

## Gotchas

- If one story packs multiple outcomes, requirements and planning cannot tell what the user actually needs first. Split independent outcomes into separate stories.
- If the action names an implementation task like refactoring or adding an endpoint, the story stops describing user value and downstream specs inherit engineering trivia. Rewrite it in user language.
- If the benefit clause is generic filler like “so that it works better,” the story passes syntax checks while still hiding the real why. State the concrete value or use `TODO: Confirm`.
- If you guess a missing actor to make the sentence elegant, later requirements rest on invented intent. Keep the story and mark the missing field `TODO: Confirm` inline.
- If you change the sentence structure casually, validators and downstream skills cannot rely on stable parsing. Keep actor, action, then benefit in the canonical order.
- If additional grouping or numbering replaces the story sentence, humans may still understand it but the contract has drifted. Treat extra structure as wrapper metadata only.
- If `source_artifacts.charter` is missing, reviewers cannot tell which approved framing the stories came from. Keep lineage explicit.

## Deliverables

- Canonical user-story artifact with deterministic provenance.
- Canonical user-story sentences following the actor-action-benefit contract.
- Explicit `TODO: Confirm` markers for unresolved actor, action, or benefit fields.
- Stories ready for downstream requirements, design, or planning work.

## Validation Checklist

- Canonical frontmatter passes shared provenance validation.
- `source_artifacts.charter` is present.
- Each story is user-visible rather than implementation-only.
- Each story uses `As a` or `As an`, then `I want`, then `so that`.
- Actor, action, and benefit are all present unless one is explicitly `TODO: Confirm`.
- Each story ends with a period.
- Additional structure does not change the sentence contract.

## Deterministic Validation

- `bash scripts/validate_user_stories.sh <user-stories-file>`
