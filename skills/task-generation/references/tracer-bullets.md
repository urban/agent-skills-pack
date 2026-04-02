# Tracer Bullets

Tracer bullets are a development technique for reducing risk while building real software. The idea is to implement a very thin end-to-end path early, observe results, and adjust quickly as you learn.

The metaphor is practical: fire something visible through the system, see where it lands, then correct aim.

## Canonical idea

Tracer bullets are used to:

- validate direction early,
- expose integration problems quickly,
- create short feedback loops,
- reduce surprise in later delivery.

They are intentionally small but complete, and are expected to be refined over time.

## Tracer bullets vs prototypes

Tracer bullets and prototypes are not the same:

- Tracer bullet: production-bound code that stays and improves.
- Prototype: exploratory code that can be discarded.

If work is meant to be thrown away, it is not a tracer bullet.

## Defining characteristics

A tracer-bullet slice should be:

1. Vertical.
   It crosses the relevant layers for one user-visible or integration-visible behavior.
2. Thin.
   It implements the smallest useful version of that behavior.
3. Executable.
   It can be run, demonstrated, and validated.
4. Non-throwaway.
   The implementation remains in the codebase and is extended.
5. Feedback-oriented.
   It is small enough to complete quickly and learn from quickly.

## How to use the technique

Use this loop:

1. Pick one concrete outcome.
2. Build the smallest end-to-end path that achieves it.
3. Add focused acceptance criteria.
4. Demo and test the slice.
5. Use feedback to adjust architecture, scope, or next slice.
6. Repeat with another thin slice.

This approach intentionally favors many small corrections over one large late correction.

## Choosing the first slice

A strong first tracer bullet usually:

- covers one happy-path scenario,
- includes minimal but real integration points,
- provides observable behavior,
- proves both user value and technical path.

Avoid foundation-only first slices that deliver no observable outcome.

## Dependency guidance

Set dependencies based on behavior, not layer order.

- Strong dependency: "Basic install flow works end-to-end, so remote-path validation can build on it."
- Weak dependency: "Finish service layer before command layer starts."

Dependencies should describe which working behavior must exist first.

## Validation checklist

Before accepting a slice, confirm:

1. Can it be demoed independently?
2. Does it cross all necessary layers for that demo?
3. Is scope intentionally small?
4. Will the code remain and be improved?
5. Is it tied to a specific planned outcome?

If any answer is no, split or rewrite the slice.

## Anti-patterns

- Horizontal tasks by architecture layer.
- Large slices that delay feedback.
- "Spike-only" tasks framed as tracer bullets.
- Missing acceptance criteria.
- Delaying integration until late phases.
