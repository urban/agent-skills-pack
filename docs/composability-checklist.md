# Composability checklist

Use this checklist before finalizing a skill.

## Runtime composition

Confirm that:

- the `description` makes the skill easy to select at runtime
- runtime use does not depend on `metadata.dependencies`
- the skill has clear boundaries
- another agent could choose it without knowing the full package graph

Prefer loose composition through good descriptions, bounded outputs, and explicit contracts.

## Boundaries

Confirm that:

- foundational skills define reusable leaf contracts and validation
- expertise skills apply those contracts within one bounded artifact or analysis job
- orchestration skills own workflow-wide coordination without restating contract rules
- child skills do not know parent workflow framing
- planning does not redefine requirements
- requirements do not become technical design
- reconstruction does not invent intent

## Contracts

If the skill works with a shared artifact type, confirm that:

- section order matches the canonical contract
- naming matches the canonical contract
- validation matches the canonical contract
- canonical provenance and `source_artifacts` are applied on create
- workflow-level lineage expectations come from orchestration rather than foundational or expertise contracts
- uncertainty is explicit for reconstruction

Prefer reusing a `write-*` skill over copying its rules.

## Reuse

Confirm that:

- the skill has one clear responsibility
- the owned output is explicit
- install-time dependencies are declared when packaging requires them
- another orchestration could reuse the skill unchanged

## Agent use

Prefer:

- deterministic filenames
- canonical frontmatter for created artifacts
- explicit headings
- concise instructions
- direct workflow order
- local validation commands

Avoid vague prose, hidden assumptions, and formats that require structure inference.

## Reconstruction

For reconstruction-heavy skills, confirm that:

- code, tests, config, and repo structure are primary evidence
- implemented reality is described instead of imagined intent
- weak conclusions are marked explicitly
- compatibility with the authored contract is preserved when the artifact type is shared
