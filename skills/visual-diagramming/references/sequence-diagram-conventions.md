Use this reference when authoring or reviewing `sequenceDiagram` diagrams and message ordering or participant clarity matters.

## Conventions

- Use `sequenceDiagram` when the core question is who interacts with whom and in what order.
- Name participants by the same roles or components used in the surrounding artifact.
- Keep one main interaction story per diagram. Split retries, side channels, or unrelated flows when they distract from the primary exchange.
- Distinguish requests from responses clearly through labels and direction.
- Use `alt`, `opt`, or `loop` blocks when conditions or repetition materially change behavior.
- Consider `autonumber` when step order matters for review, implementation, or discussion.
- Use notes sparingly for protocol detail that cannot fit cleanly in a message label.

## Minimum completeness

- Every participant that sends or receives an important message appears explicitly.
- The primary request and response path is visible.
- Material alternate outcomes appear when omission would hide real behavior.
- Message labels describe the action or payload clearly enough to verify against evidence.

## Review checks

- Participants are named consistently with the rest of the artifact.
- The sequence shows a clear beginning, major exchange points, and completion or failure.
- Conditional or repeated behavior uses Mermaid blocks instead of ad hoc commentary when that structure matters.
- Message labels read like actions or exchanges, not vague summaries.
- The diagram remains readable without forcing protocol details into every arrow.

## Gotchas

- If a sequence diagram is used to explain lifecycle rules, reviewers miss the state model. Switch to `stateDiagram-v2` when the concern is allowed transitions.
- If alternate paths are left out, the diagram may look cleaner but becomes misleading.
- If every implementation detail is added as its own message, the sequence stops clarifying and starts mirroring code line by line.
- If participant names differ from artifact terminology, the diagram becomes hard to verify.
