Use this reference when authoring or reviewing `stateDiagram-v2` diagrams and naming clarity matters.

## Naming guidance

- **States:** use nouns or adjectives that describe a condition or mode, such as `Idle`, `Loading`, `Authenticated`, or `Error`.
- **Events and transitions:** use verbs, such as `submit`, `cancel`, `fail`, `load`, `sign in`, or `clear form data`.
- **Actions:** use verbs or verb phrases, such as `sendRequest`, `displayError`, or `updateData`.
- **Guards:** name them like boolean conditions, often adjectives or past participles, such as `isLoggedIn`, `hasValidData`, or `isExpired`.
- **Parent states:** use compound nouns when nesting helps, such as `Viewing Shopping Cart`, with child states like `Empty` and `Populated`.
- **Invoked actors:** use nouns or gerunds that describe the service being called, such as `fetchingData` or `userAuthentication`.

## Review checks

- State names read like conditions or modes, not actions.
- Transition labels read like triggers, not destination summaries.
- Actions describe work being performed, not state names.
- Guards read like boolean predicates.
- Nested parent states describe the broader mode that owns the child states.
- Invoked actor names describe the external capability or ongoing service.

## Gotchas

- If states are named with verbs, readers confuse conditions with triggers and the lifecycle becomes harder to scan.
- If transitions are named with nouns, the diagram loses the event semantics that explain why the state changed.
- If guards read like prose instead of predicates, reviewers cannot tell whether the label is a condition or commentary.
- If parent and child state names do not share a clear hierarchy, nesting adds clutter instead of structure.
- If invoked actors are named like implementation details rather than capabilities, the diagram leaks mechanics instead of behavior.
