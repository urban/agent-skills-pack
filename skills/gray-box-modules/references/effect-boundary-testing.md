# Effect Boundary Testing

Use this reference when defining boundary tests for a gray-box module implemented with Effect.

Testing rules:

- Test the module through its public service contract, not through private helpers.
- Provide test doubles and fixtures with layers rather than bypassing the service boundary.
- Verify caller-visible success cases, typed failures, and key invariants.
- Assert lifecycle behavior when the boundary owns resources, background work, or scoped cleanup.
- Keep tests resilient to internal refactors by avoiding assertions on helper sequencing or file structure.
- Do not lock tests to internal `PubSub` topics, batching groups, `RequestResolver` behavior, or `ManagedRuntime` wiring unless those are explicit boundary commitments.

Preferred patterns:

- Use Effect-based tests for Effect services and provide shared test layers where needed.
- Use `Layer.provideMerge` when tests must inspect a supporting test service alongside the module.
- Validate boundary errors by tag and shape rather than string matching.
- For time-based behavior, use Effect test time controls instead of real waiting.
- For streaming boundaries, test the visible stream contract and termination or failure behavior, not the internal producer topology.

Evidence rules for reconstruction:

- Treat dedicated service tests, explicit test layers, and stable entrypoints as strong evidence for a real module boundary.
- Treat incidental helper tests or directory grouping alone as weak evidence.
- If tests exercise internals more than the public contract, avoid overclaiming a durable module seam.
