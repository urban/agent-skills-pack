# Gray-Box Evidence

Keep `derive-technical-design` focused on reconstructing the as-built technical design artifact.

Use `gray-box-modules` only when the repository already exposes a real bounded capability with a caller-visible seam.

Evidence rules:

- Keep this role responsible for documenting the current architecture, interfaces, data flow, operational concerns, and testing strategy.
- Do not treat gray-box modules as required for every reconstruction run.
- Document a gray-box module only when the codebase shows cohesive ownership, stable entrypoints, explicit dependency wiring, isolated lifecycle control, or dedicated boundary tests around that seam.
- If those signals are partial or conflicting, describe the observed structure without upgrading it to a confident module claim.
- Mark inferred boundaries or unclear ownership as `TODO: Confirm` instead of inventing stronger certainty.
