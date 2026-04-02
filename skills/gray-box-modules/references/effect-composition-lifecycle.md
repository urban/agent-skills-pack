# Effect Composition And Lifecycle

Use this reference when describing how an Effect gray-box module is wired and who owns its lifecycle.

Composition rules:

- Build the module with `Layer.effect` or other layer constructors so acquisition is centralized.
- Use `Layer.provide` when the module should hide its dependencies and expose only its own service.
- Use `Layer.provideMerge` when tests or higher-level composition intentionally need both the module and a dependency exposed.
- Use `Layer.unwrap` when runtime config or effectful setup determines which layer to build.
- Use `LayerMap.Service` for dynamically keyed resources with caching and release semantics.
- Keep `ManagedRuntime` outside the deep module where possible. Use it to adapt the module into framework handlers, jobs, or callbacks at integration edges.

Lifecycle rules:

- Treat the layer as the owner of resource acquisition, background fibers, and cleanup.
- Use scoped resource patterns for connections, subscriptions, workers, and long-lived processes.
- Let the module own `PubSub`, stream producers, request batching state, and background supervision when those are implementation details.
- Keep lifecycle responsibility at module boundaries rather than scattering it across callers.
- Document whether the module is pure, scoped, memoized, singleton-like, or key-scoped when that affects behavior.

Boundary guidance:

- Callers should depend on service methods, not on how the layer assembles dependencies.
- Boundary tests should verify visible behavior and lifecycle outcomes without freezing internal wiring choreography.
- If the module internally polls, batches, subscribes, or fans out events, describe the caller-visible guarantees rather than the internal mechanism.
- If lifecycle ownership is unclear in the codebase, mark it `TODO: Confirm`.
