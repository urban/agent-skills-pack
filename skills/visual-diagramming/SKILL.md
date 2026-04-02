---
name: visual-diagramming
description: Select and author Mermaid diagrams that clarify systems, interactions, behavior, data relationships, and persona journeys. Use when an artifact needs a visual explanation that communicates faster than prose without drifting beyond the evidence.
metadata:
  version: 0.1.0
  layer: foundational
---

## Rules

- Prefer diagrams when they communicate the shape, behavior, or experience faster than prose because agents are communicating work to humans.
- Use prose to add constraints, assumptions, exceptions, tradeoffs, or details the diagram cannot carry; do not restate the diagram in sentence form.
- Choose the diagram that answers the main question with the least ambiguity, not the one that is most familiar.
- Use multiple small diagrams when one diagram would mix concerns such as structure, ordering, state, and data shape.
- Keep labels consistent with the surrounding artifact because renamed actors, components, or entities make the diagram unverifiable.
- In derived artifacts, keep every diagram evidence-based and mark weak inferences as `TODO: Confirm`.
- Omit a diagram type when it adds no clarity and say why instead of forcing decorative coverage.

## Supported diagrams

- `journey`: use for persona stages, actions, touchpoints, and pain points. Best when the question is what the actor experiences over time.
- `sequenceDiagram`: use for ordered interactions between actors, components, or systems. Best when the question is who talks to whom and in what order.
- `stateDiagram-v2`: use for lifecycle behavior and allowed transitions. Best when the question is how one entity, workflow, or process changes state. Read `references/state-diagram-naming.md` when authoring or reviewing state-diagram naming.
- `flowchart`: use for process flow, decision flow, routing, and system context. Best when the question is how work moves through steps or boundaries.
- `erDiagram`: use for persistent entities and relationships. Best when the question is what durable records exist and how they relate.

## Artifact guidance

### Technical design

- Use diagrams where they clarify architecture better than prose.
- Prefer `flowchart` for system context and major data or control flow.
- Prefer `sequenceDiagram` for interface orchestration and integration behavior.
- Prefer `stateDiagram-v2` for meaningful workflow or entity lifecycle rules.
- Prefer `erDiagram` when persistent data shape is central to correctness or implementation.

### Derived technical design

- Use the same diagram types as authored technical design, but only when code, tests, config, or existing documentation support them.
- If the repository shows behavior but not intent, diagram the observed behavior and mark uncertain design claims as `TODO: Confirm`.
- Do not clean up or idealize the architecture in diagrams beyond what the evidence supports.

### User stories

- Prefer `journey` for persona-centered stories because it keeps the focus on stages, touchpoints, and friction.
- Use `sequenceDiagram` only when interaction ordering is central to the story.
- Use `flowchart` only when branching paths or decision logic matter more than lived experience.
- Avoid technical diagrams that pull the artifact away from actor value.

## Gotchas

- If you add a diagram and then paraphrase every node and arrow below it, the artifact gets longer without getting clearer. Add only the constraints or caveats the diagram cannot show.
- If you pick a sequence diagram for a state problem, reviewers see steps but miss the lifecycle rules. Use `stateDiagram-v2` when the real question is allowed transitions.
- If you force every artifact to include every diagram type, diagrams become ceremony and humans stop trusting them. Include only diagrams that remove ambiguity.
- If derived diagrams smooth over contradictions in the codebase, the artifact looks polished but becomes fiction. Diagram implemented reality and mark weak spots `TODO: Confirm`.
- If one diagram tries to show personas, orchestration, state, and entities at once, it becomes unreadable and nobody checks it. Split by concern.
- If labels in the diagram do not match names used elsewhere in the artifact, readers waste time translating instead of understanding. Reuse the same names everywhere.

## References

- [`references/state-diagram-naming.md`](./references/state-diagram-naming.md): Read when: authoring or reviewing `stateDiagram-v2` naming for states, transitions, actions, guards, parent states, or invoked actors.

## Validation Checklist

- The chosen diagram answers the artifact's main question faster than prose.
- Prose adds constraints or detail not visible in the diagram and does not repeat it.
- Diagram type matches the concern: journey, interaction order, state, flow, or entity relationships.
- In `stateDiagram-v2`, load the naming reference when role-appropriate labels are unclear.
- Large or mixed concerns are split into multiple focused diagrams.
- Labels match the surrounding artifact terminology.
- Derived diagrams stay evidence-based and use `TODO: Confirm` for weak inferences.
- Omitted diagram types are omitted intentionally, with a short reason when omission might be surprising.
