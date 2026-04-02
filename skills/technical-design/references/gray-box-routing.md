# Gray-Box Routing

Keep `technical-design` focused on the specification artifact.

Use this reference only when a design review asks whether gray-box work belongs inside the technical-design artifact or in separate follow-on execution work.

Routing rules:

- Keep the design artifact responsible for architecture, interfaces, tradeoffs, and testing strategy.
- Use the foundational `gray-box-modules` contract inside the artifact whenever the design identifies a meaningful bounded capability with a durable responsibility.
- Do not turn this role into module implementation or gray-box refactor work.
- If separate implementation or refactor work is later approved, keep it as additive follow-on work rather than a required handoff for completing the design artifact.
- If the boundary is still unclear, stay inside the design artifact until the unresolved area is called out as `TODO: Confirm`.
