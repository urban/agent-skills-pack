Use this reference when authoring or reviewing `flowchart` diagrams and the diagram could represent process, routing, or system context.

## Choose the right flowchart mode

### Process flow
Use when the question is how work moves through steps and decisions.

- Show a clear start, major actions, decisions, and exits or handoffs.
- Label decision branches explicitly.
- Keep action labels short and verb-oriented.
- Prefer labels that describe work being done, not component ownership.

### Routing or decision flow
Use when the question is how inputs, requests, or cases branch.

- Make branch conditions explicit.
- Avoid burying important branching logic inside node text.
- Show the path that ends the flow or hands work elsewhere.
- Keep the diagram focused on routing logic rather than implementation internals.

### Architecture or system context
Use when the question is what systems, actors, boundaries, or capabilities connect.

- Prefer stable system, service, actor, or boundary names over step-like labels.
- Show relationships and boundaries without implying a time-ordered sequence.
- Group related components with subgraphs only when the grouping reflects a real boundary or layer.
- Label edges by relationship or dependency when unlabeled arrows would be ambiguous.
- If time order is central, switch to `sequenceDiagram`.

## Architecture vs process distinction

Use a **process flowchart** when arrows mean:
- progression through work
- decisions and branching
- handoffs between steps

Use an **architecture flowchart** when arrows mean:
- dependency
- communication path
- containment boundary crossing
- data or control relationship without claiming sequence timing

If readers could mistake the arrows for time order, either relabel the edges clearly or switch to `sequenceDiagram`.
If readers could mistake the arrows for allowed state changes, switch to `stateDiagram-v2`.

## Minimum completeness

- The entry point, relevant boundary, or scope anchor is clear.
- Important decisions or relationship labels are explicit.
- The overall direction is coherent enough to follow without explanation.
- The diagram answers one main question instead of mixing process, state, and data shape.

## Review checks

- The chosen flowchart mode matches the question being answered.
- Decision labels explain why paths differ.
- The diagram does not accidentally imply state transitions or message order it does not intend to show.
- Labels are concise and consistent with the surrounding artifact.
- Large diagrams are split when multiple boundaries or stories compete.

## Gotchas

- If a flowchart tries to show both lifecycle states and process steps, readers cannot tell whether arrows mean transition or progression.
- If a system context flowchart uses many arrows without labels, the relationships become guesswork.
- If decision text lives only in prose below the diagram, the flowchart loses its purpose.
- If every component in the system appears in one flowchart, the diagram stops being reviewable.
