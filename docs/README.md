# Agent Skills Spec Pack Docs

This directory explains what `@urban/agent-skills-pack` is for, how the layer model works, how provenance and traceability work, and which rules should guide future changes.

All package skills live under `../skills/`. A skill's layer is declared in its `metadata.layer` frontmatter.

Provenance and traceability are core package concepts. Created artifacts should carry canonical frontmatter that records deterministic skill provenance and source-artifact lineage. See [provenance.md](./provenance.md).

Start here:

- [purpose.md](./purpose.md)
  What problem the skill pack solves and what artifacts it owns.
- [provenance.md](./provenance.md)
  Canonical artifact provenance, source-artifact lineage, and validation expectations.
- [design-rationale.md](./design-rationale.md)
  Why the pack separates foundational contracts, expertise entry skills, and orchestration skills.
- [development-principles.md](./development-principles.md)
  The rules for extending the pack without breaking reversibility, provenance, traceability, or layer boundaries.
- [skill-expertise-selection.md](./skill-expertise-selection.md)
  When a new skill should exist and which layer it should belong to.
- [skill-structure.md](./skill-structure.md)
  How to structure a skill directory and `SKILL.md` under `skills/`.
- [composability-checklist.md](./composability-checklist.md)
  Final checks for reuse, boundaries, contracts, and agent usability.
- [progressive-disclosure.md](./progressive-disclosure.md)
  How to split package guidance across `AGENTS.md`, `SKILL.md`, and supporting resources.
