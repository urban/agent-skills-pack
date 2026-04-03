# Skill expertise selection

Use this guide when deciding whether a new skill should exist and which layer it belongs to.

## Create a new skill only when needed

Create a new skill only if at least one of these is true:

- a new artifact needs its own stable contract or validator
- a reusable orchestration is needed across repositories or parent skills
- an existing skill is doing more than one job and should be split
- a missing layer would make the pack less reversible or less composable

Do not create a new skill just to hold:

- project-specific content
- one-off analysis
- logic that belongs in an existing skill

## Choose one layer

Every skill belongs to exactly one layer and lives under `skills/<skill-name>/`.
Declare the layer in `metadata.layer`.

### Foundational

Use this layer for shared contracts, templates, naming, validators, or provenance rules.

Examples:

- `artifact-naming`
- `write-charter`
- `write-user-stories`
- `write-requirements`
- `write-technical-design`
- `write-execution-plan`
- `write-task-tracking`
- `gray-box-modules`

### Expertise

Use this layer when the skill applies foundational contracts within one bounded responsibility.

Examples:

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
- depend only on foundational skills
- declare `metadata.archetype` and `metadata.domain`
- keep optional routing guidance in local `references/`

### Orchestration

Use this layer when the skill coordinates multiple expertise skills into one larger flow.

Examples:

- `specification-authoring`
- `specification-to-execution`
- `specification-reconstruction`

Orchestration skills must:

- depend only on expertise skills
- preserve one end-to-end flow
- avoid restating foundational contract rules

## Selection checks

Before creating a skill, confirm that:

- it owns one clear output or coordination outcome
- it does not redefine adjacent artifacts
- it can declare dependencies instead of inlining their rules
- it fits exactly one layer

## Split signals

Split a skill instead of expanding it when:

- it both defines a reusable contract and performs expertise execution
- it needs dependencies from both foundational and orchestration layers
- it tries to own multiple artifact types
- it mixes authoring, reconstruction, and planning sources of truth
