# Deciding whether a skill should exist

Use this guide before adding a new skill or splitting an existing one.

## Create a new skill only when needed

Create a new skill only if at least one of these is true:

- a new artifact needs its own stable contract or validator
- a reusable orchestration is needed across repositories or parent skills
- an existing skill is doing more than one job and should be split
- a missing layer would make the package less reversible or less composable

Do not create a new skill just to hold:

- project-specific content
- one-off analysis
- logic that belongs in an existing skill

## Pick exactly one layer

Every skill belongs to exactly one layer and lives under `skills/<skill-name>/`.

### Foundational

Use this layer for generic shared contracts, templates, naming, validators, metadata, or provenance mechanics.

Typical examples:

- `artifact-naming`
- `write-charter`
- `write-user-stories`
- `write-requirements`
- `write-technical-design`
- `write-execution-plan`
- `write-task-tracking`
- `gray-box-modules`

Foundational skills should be reusable leaves. They may own shared naming and normalization such as `<project-name>` resolution, shared metadata shape, validators, templates, and provenance assembly mechanics. They must not own workflow-specific spec-pack roots, expertise-owned filenames, or workflow-level lineage policy.

### Expertise

Use this layer when the skill applies foundational contracts within one bounded responsibility.

Typical examples:

- `charter`
- `user-story-authoring`
- `requirements`
- `derive-charter`
- `derive-requirements`
- `technical-design`
- `derive-technical-design`
- `execution-planning`
- `task-generation`

Expertise skills must:

- own one output or one bounded analysis/planning job
- behave like leaves relative to orchestration
- depend only on foundational skills
- declare `metadata.archetype` and `metadata.domain`

Expertise skills should own the artifact filename for that output, describe same-pack dependency expectations relative to the spec-pack root when needed, and define the local validation invocation shape when useful.

They should not define:

- workflow-level `source_artifacts` lineage policy
- spec-pack root placement
- `<project-name>`
- root workflow identity

### Orchestration

Use this layer when the skill coordinates multiple expertise skills into one larger flow.

Typical examples:

- `specification-authoring`
- `specification-to-execution`
- `specification-reconstruction`

Orchestration skills must:

- depend on expertise skills for artifact-producing work
- preserve one end-to-end flow
- avoid restating foundational contract rules
- own workflow-wide coordination such as sequencing, approvals, root workflow provenance, and cross-artifact consistency checks

They may also depend on selected foundational leaf contracts when the concern is workflow-wide coordination rather than artifact-specific authoring. Common cases:

- naming needed to resolve one workflow-wide `<project-name>`
- spec-pack root selection
- provenance assembly support

They must not use foundational dependencies to replace expertise artifact contracts.

## Selection checks

Before creating a skill, confirm that:

- it owns one clear output or coordination outcome
- it does not redefine adjacent artifacts
- it can declare dependencies instead of copying their rules
- it fits exactly one layer

## Split signals

Split a skill instead of expanding it when:

- it both defines a reusable contract and performs expertise execution
- it needs dependencies from both foundational and orchestration layers
- it tries to own multiple artifact types
- it mixes authoring, reconstruction, and planning sources of truth

## Default bias

When uncertain, prefer:

- foundational reuse over restating rules
- one bounded expertise skill over a multi-purpose skill
- orchestration over cross-expertise coupling
- explicit validation
- explicit uncertainty
- composition over duplication
