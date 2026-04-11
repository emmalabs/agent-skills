# Refactor And Optimize Heuristics

Use this reference when the main workflow identifies the task, but the right change shape is still unclear.

## Simplification and deletion first

- Treat **net removal** of lines, branches, and public symbols in the touched area as success unless new behavior is required.
- Before adding a new type, file, or wrapper, list what can be **deleted** or **merged** instead; prefer that list non-empty when the code is messy.
- A refactor that only **adds** indirection while leaving obsolete implementations in the tree is incomplete; remove the superseded path when tests pass.

## Dead code heuristics

- Search for references to exports and top-level symbols before assuming unused; use compiler or linter unused warnings when available.
- Watch for dead code behind always-true or always-false conditions, impossible type narrows, and duplicate `return` paths.
- Remove unused parameters only when the signature is internal or all callers are updated safely.
- Configuration, env keys, and feature flags with no readers are dead; confirm with search before removal.
- In UI code, unused event handlers, template bindings, subscriptions, or inputs left after a feature change are common dead weight.
- CSS/SCSS rules with no matching class or element in the component, and duplicate selectors left after a markup change, are style dead weight.

## Markup, CSS, and SCSS

- **Reuse**: grep or search for existing components, shared templates, and shared classes before adding new ones; prefer composition of known building blocks.
- **HTML cleanup**: flatten redundant wrapper `div`s when structure allows; remove decorative classes that duplicate utility combinations already used elsewhere.
- **Nested SCSS**: nest rules under the component root (or BEM block) so locality is obvious; avoid leaking long selector chains into global files when the project uses per-component styles.
- **Consistency**: align with the project's spacing, typography, and layout tokens or variables rather than introducing new magic numbers alongside existing ones.
- **Simplicity**: fewer distinct class names on a node is usually better; merge styling intent into one reusable pattern when it repeats across screens.

## Types, interfaces, and public APIs

- Prefer the **narrowest** exported interface that callers need; widen only when multiple clients genuinely require the same surface.
- Default to **concrete, readable types** over heavy generic signatures unless the generic removes real duplication without obscuring usage.
- Avoid exporting types that mirror internal implementation detail; export stable, **generic** names at module boundaries where the domain allows.
- Methods: prefer a small set of clear verbs over many thin overloads or boolean-driven variants unless the language idiom demands otherwise.

## Spaghetti and tangling

- Prefer **linearize then extract**: reduce nesting with guard clauses and early returns before splitting into many tiny functions.
- Long methods that alternate unrelated concerns (I/O, mapping, business rules) are candidates to **segment by concern** or **pull one concern out**, not to wrap the whole thing in a facade.
- Callback pyramids, implicit ordering in `Promise.all` misuse, and mixed sync/async in one block are smell signals; simplify sequencing first.
- Circular imports, "friend" modules that reach into each other's internals, and god objects are structural spaghetti; fix boundaries or merge modules before adding more glue.

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
