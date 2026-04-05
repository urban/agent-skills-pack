# Skill description guidelines

Use this guide when writing or reviewing the `description` field in `skills/<skill-name>/SKILL.md`.

The description is routing metadata. It should help a human or agent select the right skill quickly without requiring knowledge of the full package graph.

## What a good description must do

A good description should say:

- what the skill owns
- what source of truth or framing it works from when that matters
- when to use it

A description should identify the skill, not snapshot its current implementation.

## Stability goal

Write descriptions so they usually survive these changes without needing a rewrite:

- dependency changes
- workflow refinements
- inserted review or approval steps
- optional guidance changes
- validator or template swaps
- additional workflows reusing the skill
- new artifact types added to the package

If a description would become false after one of those changes, it is probably too specific.

## Core rule

Describe:

- stable ownership
- stable source-of-truth orientation
- stable use case

Avoid describing:

- exact child routing
- current dependency composition
- exact validator or template names
- optional helper guidance
- the full current consumer list unless that boundary is intrinsic to the skill

## Layer-specific guidance

### Foundational skills

Emphasize:

- the reusable contract or mechanism the skill owns
- the bounded concern it standardizes
- the general situations where that contract is needed

Avoid:

- listing all current workflows or artifact consumers
- narrowing the description to today's specialist users when the contract is broader
- describing current downstream composition in the one-line summary

Preferred shape:

- `Define the shared contract for ...`
- `Resolve and normalize ...`
- `Provide canonical ...`

### Specialist skills

Emphasize:

- the one bounded artifact or analysis output the skill owns
- the source of truth it works from
- when the caller should use it

Avoid:

- naming all supporting foundational dependencies
- embedding optional techniques or helpers in the description
- describing workflow-wide sequencing or lineage rules

Preferred shape:

- `Produce ... from approved ...`
- `Reconstruct ... from repository evidence ...`
- `Break ... into ...`

### Coordination skills

Emphasize:

- the workflow or phase the skill coordinates
- the workflow source of truth
- the coordinated outcome

Avoid:

- `by routing through ...`
- exact child ordering
- approval-gate details
- current workflow graph details that belong in the body

Preferred shape:

- `Orchestrate ... from approved ...`
- `Orchestrate reconstruction of ... from repository evidence ...`

## What belongs in the description versus the body

Keep in the description:

- ownership
- bounded scope
- source-of-truth orientation
- simple `Use when ...` routing language

Keep in the skill body instead:

- exact workflow order
- approval or review gates
- dependency-specific guidance
- optional diagrams or method details
- validator commands
- lineage maps
- special cases and gotchas

## Recommended template

Use this shape unless the skill needs a stronger variant:

- `<Verb> <bounded artifact, contract, or workflow> from/for <source of truth or framing>. Use when <stable routing cue>.`

Examples:

- `Define canonical provenance and source-artifact lineage for package artifacts. Use when a skill creates or validates a package artifact that must carry deterministic metadata.`
- `Produce requirements artifacts from approved product framing and approved user stories. Use when a user needs product obligations and constraints documented before design or implementation.`
- `Orchestrate execution artifacts from an approved specification pack. Use when a user needs execution planning and local task tracking created from approved specification context.`

## Review checks

Before shipping a description, confirm that:

- it states stable ownership clearly
- it makes the skill easy to select at runtime
- it does not require knowing the full package graph
- it avoids exact child routing
- it avoids naming optional helper dependencies
- it would remain true if the workflow grows or dependencies change

## Anti-patterns

Avoid descriptions like these:

- `Orchestrate ... by routing through A, B, and C ...`
- `Produce ... using X contract plus Y guidance ...`
- `Use when charter, requirements, design, and execution artifacts all need ...`

Those patterns belong in the body unless they are truly part of the skill's stable identity.
