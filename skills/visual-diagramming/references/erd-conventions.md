Use this reference when authoring or reviewing `erDiagram` diagrams and relationship correctness or attribute scope matters.

## Conventions

- Use `erDiagram` when the question is what durable records exist and how they relate.
- Include entities that matter to the artifact's claim. Omit peripheral tables or records unless they affect correctness.
- Show relationship cardinality only when the evidence supports it.
- Mark keys when they matter for implementation, traceability, or review. Do not invent keys that the evidence does not support.
- Keep attributes focused. Include fields only when they are central to the design or behavior being explained.
- Distinguish conceptual ERDs from implementation ERDs in accompanying notes when needed.

## Minimum completeness

- Entities relevant to the claim are present.
- Relationships between those entities are shown.
- Cardinality is included when known and omitted or qualified when uncertain.
- Attributes or keys appear only when they materially improve correctness or implementation understanding.

## Review checks

- Entity names match the surrounding artifact and source evidence.
- Relationship labels and cardinality reflect implemented or explicitly specified behavior.
- The diagram does not imply schema detail that has not been observed or approved.
- Field lists are short enough to keep the relationship structure readable.
- Notes distinguish conceptual structure from implementation-specific detail when both could be inferred.

## Gotchas

- If every field is included by default, the ERD becomes a schema dump instead of a clarifying diagram.
- If cardinality is guessed, downstream readers may treat speculation as a design contract.
- If a conceptual ERD is presented like an implementation schema, reviewers may infer constraints that do not exist.
- If relationship names differ from the rest of the artifact, the data model becomes harder to verify.
