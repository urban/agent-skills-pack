# Progressive disclosure

Use progressive disclosure so an agent loads only the guidance needed for the task.

Keep always-on rules small, keep workflow instructions in the skill, and move deeper detail into support docs.

## Loading model

Use these layers:

- `AGENTS.md` — package-wide rules, boundaries, routing
- `SKILL.md` — workflow and constraints for one skill
- `docs/`, `references/`, `assets/`, `scripts/` — optional detail, templates, validators

All package skills live under `skills/`. Package docs live under `docs/`. Skill-local support files live under `skills/<skill-name>/`.

## AGENTS.md

Keep `AGENTS.md` short and authoritative.

Put these there:

- pack-wide invariants
- non-negotiable boundaries
- the layer model
- links to deeper docs

Do not put every situational rule or example there.

## SKILL.md

Keep `SKILL.md` focused on what an agent must do when the skill is selected.

Put these there:

- purpose
- workflow
- constraints
- required deliverables
- validation steps
- links to deeper resources when needed

Do not use it for optional explanation or maintenance detail.

## Supporting docs

Move material into `docs/` or `references/` when it is:

- situational
- shared by multiple skills
- long enough to distract from the workflow
- mainly useful during authoring or maintenance

## Navigation rules

When splitting guidance across files:

- link instead of duplicating
- give each rule one home
- add routing near the decision point
- use clear link labels

Prefer one simple routing table over scattered links.

## Anti-patterns

Avoid:

- putting all guidance in `AGENTS.md`
- putting all detail in `SKILL.md`
- duplicating the same rule across files
- vague links that do not say when to read them
- deep reference trees that require blind exploration

## Quick test

When adding guidance, ask:

1. Must every agent see this before touching any skill in the package? Put it in `AGENTS.md`.
2. Must every agent running one specific skill see this? Put it in that skill's `SKILL.md`.
3. Is it optional, situational, shared, or deeper explanation? Put it in `docs/` or `references/` and link to it.
