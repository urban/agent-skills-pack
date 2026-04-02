# Diagram Evidence and Recovery Wording

Use this reference when a derived technical design needs help filling the four required diagram slots without overstating certainty.

## Evidence rules

- Diagram only what code, tests, config, logs, or existing docs support.
- If a flow, state, relationship, or interaction is only partially visible, narrow the diagram to the proven part.
- If the slot still matters but evidence is weak, keep the slot and use `TODO: Confirm`.
- If the slot would add no clarity for the observed system, use `Not needed:` with a short reason.
- Do not "improve" the recovered architecture in diagrams.

## Slot guidance

### Context Flowchart

Use when repo evidence shows runtime boundaries, entrypoints, major processing stages, or external systems.

Use `Not needed:` only when the surrounding prose already makes the runtime boundary trivial and a flowchart would add no new clarity.

### Behavior State Diagram

Use when tests, enums, status fields, workflow handlers, retries, or recovery logic show a real lifecycle.

Use `Not needed:` when the observed system has no meaningful lifecycle beyond straight-through processing.

### Entity Relationship Diagram

Use when schemas, migrations, models, tables, or durable records show persistent relationships.

Use `Not needed:` when persistence is opaque, external, or not central to the recovered design.

### Interaction Diagram

Use when handlers, controllers, jobs, events, or integration code show ordered collaboration between participants.

Use `Not needed:` when ordering adds no clarity beyond a simpler flowchart.

## Wording patterns

Prefer short recovery-oriented notes near the diagram.

Examples:

- `Observed from API handlers, queue workers, and integration tests.`
- `Relationship inferred from migrations and repository queries; cardinality TODO: Confirm.`
- `Not needed: the recovered system is a single-process transform with no meaningful participant choreography.`
- `TODO: Confirm: retry transition after provider timeout is implied by logs but not covered by tests.`
