# Refactor And Optimize Heuristics

Use this reference when the main workflow identifies the task, but the right change shape is still unclear.

## Refactor Heuristics

- Extract pure logic before abstracting stateful behavior.
- Split modules by responsibility boundaries, not by arbitrary line counts.
- Keep data flow explicit; reduce hidden mutation and cross-module coupling.
- Prefer deleting dead branches, obsolete flags, and pass-through wrappers over preserving them "just in case."
- Deduplicate only after confirming the duplicated code shares stable semantics and similar change cadence.
- Replace boolean parameter clusters with clearer call sites or separate functions when the behavior actually forks.

## Code Optimization Heuristics

- Remove repetition in shape conversions, validation branches, and orchestration code before inventing new abstractions.
- Prefer one clear path over several near-identical branches with minor variations.
- Inline trivial wrappers that add no policy and extract helpers only when they create a real reuse point.
- Shorten overly ceremonial code, but do not compress it until it becomes harder to read.
- Consolidate related configuration or mapping tables when they are split only by historical accident.
- Prefer boring, explicit constructs over clever one-liners that hide the intent.

## Safety Checks

- Preserve error semantics unless the task explicitly changes them.
- Preserve ordering when consumers may depend on it.
- Watch for refactors that accidentally widen visibility or mutate shared state.
- Keep concurrency behavior stable when changing async flows, retries, queues, or locking.
- Re-check logging, metrics, and tracing when moving shared code or deleting wrappers.

## Common Smells

- Giant functions mixing parsing, validation, business logic, and I/O.
- Classes that own unrelated policies or too many collaborators.
- Helpers that only forward arguments without adding policy.
- Repeated conversion between equivalent shapes across layers.
- Copy-pasted conditionals that differ only in field names or literals.
- Boilerplate setup code repeated across modules with no meaningful variation.

## Naming smells

- Names that encode types instead of roles (`data`, `info`, `handle`, `manager` without domain meaning).
- Abbreviations that are not project-standard or obvious from context.
- Same concept named differently in adjacent layers (hurts search and reasoning).
- Parameters that control multiple behaviors (boolean or enum clusters); prefer clearer call sites or split functions.

## Comment smells

- Comments that contradict the code after refactors.
- Comments that restate identifiers (`// increment i`) without adding contract or rationale.
- Missing notes where invariants, ordering assumptions, or security-sensitive behavior are non-obvious.
- Large blocks of commented-out code; prefer version control history.
