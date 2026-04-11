---
name: refactor-and-optimize
description: "Guide for code review and safe refactors across backend, frontend, scripts, and libraries. Use when improving clarity, structure, and maintainability: prioritize removing dead code, untangling spaghetti control flow, and net simplification before adding new abstractions; then apply SOLID practices, naming, comments, and deduplication without changing behavior. For UI work, include HTML/CSS cleanup, reuse of existing components and classes, nested component SCSS, and preference for simple generic types and APIs. Use for requests to review code, suggest improvements, or refactor safely. Do not use this skill for runtime, product, query, or rendering performance tuning."
---

# Refactor And Optimize

## Overview

Use this skill to turn vague requests like "clean this up" or "make this more concise" into a small, testable change set with clear behavioral guardrails. **Default to simplification**: remove dead code, flatten or clarify tangled control flow, and delete indirection before introducing new types, wrappers, or files. Prefer fewer lines and fewer concepts in the hot path over "cleaner" architecture that mostly adds surface area.

When the user asks for a **review** (not an immediate refactor), produce a structured assessment first: strengths, issues grouped by severity (must-fix vs nice-to-have), and concrete suggestions tied to line or symbol references. **Always include** a pass for dead code, unreachable or redundant paths, and spaghetti-style coupling or nesting. Offer to implement after alignment unless they asked for changes outright.

## Design principles (clarity, SOLID, practices)

Use these as a checklist while reviewing or refactoring. Prefer practical judgment over dogma; one clear module beats five tiny ones that obscure the flow.

- **Single responsibility**: each unit (function, type, module) should have one obvious reason to change; split when multiple concerns evolve on different schedules.
- **Open/closed**: favor composition and small extension points over editing the same giant conditional for every new case.
- **Liskov substitution**: subtypes must honor the contract of the base type or interface (invariants, errors, nullability); avoid surprises for callers.
- **Interface segregation**: depend on narrow types or APIs; avoid forcing callers to depend on methods they do not use.
- **Dependency inversion**: depend on abstractions at boundaries (ports); keep domain logic free of incidental infrastructure when it improves testability and clarity.
- **Readability**: explicit data flow, shallow nesting, guard clauses over deep else trees, and domain vocabulary in names.
- **Consistency**: match existing project patterns (error style, async patterns, layering); read `AGENTS.md` or local conventions when present.
- **Simple surfaces**: prefer the smallest sufficient interface, method set, or type parameterization; avoid ornate generics, deep inheritance, or "frameworky" patterns when a plain function or struct would do.

## HTML, CSS, and SCSS

When templates or styles are in scope, treat markup and styles as part of the refactor, not an afterthought.

- **Cleanup**: remove unused elements, redundant wrapper nodes, dead `class` / `ngClass` / conditional branches, obsolete inline styles, and selectors with no matching markup. Align with the project's approach to utility vs component styles.
- **Reuse before inventing**: search for existing components, directives, shared partials, and layout or utility classes that already express the same structure or visual intent; extend or compose them instead of adding parallel one-off markup or new global class names.
- **SCSS structure**: keep styles in component-scoped (or module-scoped) files where the project does; use **nested selectors** under the component (or block) root so rules mirror the template hierarchy and avoid scattering flat global selectors. Prefer nesting and variables/mixins already in the codebase over new ad-hoc patterns.
- **Class names**: prefer short, **generic** names that match existing vocabulary in the repo (for example shared `card`, `stack`, `row`) over long page-specific identifiers when semantics are the same; rename toward consistency when it reduces duplication.

Follow any stricter project docs (for example `docs/agents/frontend-layout.md` or equivalent) when they exist; they override generic advice here.

## Naming and comments

- **Names**: prefer full words and domain terms from the codebase; avoid unexplained abbreviations and single-letter names except tight local scope (indices, coordinates). Booleans: `is`/`has`/`can`/`should` prefixes where it reads naturally. Functions are verbs; types are nouns. Rename in dedicated commits or steps when mixed with logic changes.
- **Comments**: add short comments where intent, preconditions, invariants, or non-obvious "why" would otherwise be lost; do not narrate what the next line obviously does. After refactors, update or remove stale comments. If the repository documents a comment style (for example prefer labeling blocks), follow it.

## Workflow

### 1. Frame the task precisely

Classify the request before editing:

- `Review`: assess clarity, SOLID alignment, naming, comments, duplication, **dead code**, **spaghetti control flow or hidden coupling**, **markup and style reuse / SCSS structure**, **whether APIs and types are as simple as they can be**, and risks; optionally implement fixes in a follow-up.
- `Mechanical refactor`: rename, move, extract, inline, deduplicate, delete dead code.
- `Structural refactor`: split modules, isolate responsibilities, replace control flow, narrow interfaces.
- `Code optimization`: reduce boilerplate, shorten repetitive flows, simplify branches, and make the implementation more concise.
- `Mixed`: clean structure first only when it directly supports the simplification.

Identify the real constraint:

- preserve behavior exactly,
- improve maintainability,
- reduce duplication or clutter,
- or support a future change.

State the intended win in concrete terms before changing code.

### 2. Build a fast baseline

Inspect only the code paths that matter. Prefer local evidence over assumptions:

- existing tests covering the area,
- the most duplicated or confusing paths,
- obvious repetition in control flow, data shaping, validation, or glue code,
- public interfaces that downstream code depends on.

### 2b. Explicit simplification pass (do this before adding code)

Run this checklist on the touched scope **before** proposing new helpers, classes, or layers. Prefer fixes that **delete** or **merge** over fixes that only **add**.

**Dead code and noise**

- Unused exports, functions, types, constants, imports, and private module members (confirm with the language server, repo-wide search, or tests; do not guess in dynamic-only code without evidence).
- Unreachable branches, impossible conditions, duplicate early returns, and no-op assignments.
- Commented-out blocks, obsolete feature flags, and deprecated paths that nothing calls.
- Duplicate files or near-identical copies left after a move; remove the orphan.
- In templates and styles: unused classes, duplicate markup for the same layout, orphaned SCSS blocks, and one-off classes that duplicate an existing shared pattern.

**Spaghetti and needless complexity**

- Deep nesting, long `switch`/`if` chains with overlapping conditions, and mixed async styles that obscure order of operations.
- Hidden coupling: globals, singletons, implicit shared mutable state, callbacks that reach far across modules.
- God methods or components that interleave unrelated concerns; identify seams to **split** or **linearize** (guard clauses, early returns) before extracting yet another abstraction on top.

**Simplification bias**

- If the first idea is "add a new abstraction," ask whether **inlining**, **deleting a wrapper**, or **one shared function** removes more complexity than it adds.
- After edits, the change should usually be **net fewer lines** or **net fewer public symbols** in the edited area unless the user asked for new behavior or the only safe fix requires a small new seam (for example a pure extracted function that replaces three copies).

Read [references/heuristics.md](references/heuristics.md) for more deletion and spaghetti heuristics.

### 3. Protect behavior before editing

Preserve validation integrity:

- Reuse existing tests when they already pin behavior.
- Add a focused characterization test when behavior is implicit or fragile.
- Keep API shape, side effects, error handling, and ordering stable unless the user asked to change them.
- Avoid mixing semantic changes into a refactor unless the task explicitly requires it.

### 4. Choose the smallest high-value change

Prefer the simplest change that **removes** the main source of complexity or waste:

- **Delete or merge first**: dead code, duplicate paths, pass-through layers, then deduplicate stable behavior.
- extract a pure helper only when it **replaces** repetition or clarifies a single concept; avoid new files or types whose only job is to mirror existing structure.
- remove duplication only when the shared behavior is truly stable,
- collapse indirection when wrappers add no policy,
- prefer direct data flow over layered ceremony,
- simplify repeated conditionals, mapping, and validation paths before introducing new utilities.

Read [references/heuristics.md](references/heuristics.md) when the right refactor shape or optimization target is not obvious.

### 5. Edit incrementally

Make changes in narrow slices that are easy to reason about and validate:

- separate naming/moves from logic changes when possible,
- keep public entry points stable while rewriting internals,
- **prefer deleting code over adding coordination layers**; if the diff grows mostly with new wrappers, stop and apply section 2b again,
- leave brief comments only where the new shape would otherwise be hard to follow.

**Anti-pattern to avoid**: "refactor" that only adds helpers, interfaces, or indirection while leaving old dead paths and copies in place. Remove the old path when behavior is preserved elsewhere.

### 6. Validate from narrow to broad

Run the smallest trustworthy checks first, then widen only as needed:

- targeted tests for touched behavior,
- lint or type checks for the changed surface,
- broader suites only when the risk or blast radius justifies the time.

If the code is not meaningfully clearer or **smaller in the touched scope** after the change, say so plainly instead of claiming an improvement. When reporting, call out **approximate net lines added/removed** (or symbols removed) in the edited files when practical.

### 7. Report the outcome clearly

Summarize the result in terms of:

- what changed structurally,
- what stayed behaviorally stable,
- what **dead code, duplication, clutter, or indirection was removed** (be explicit; "none found" is a valid outcome),
- whether control flow was **simplified** (flatter, fewer branches, clearer sequencing),
- naming or comment improvements when relevant,
- for UI: **markup/CSS cleanup**, **reuse** of existing components/classes, and **SCSS nesting** alignment when touched,
- whether **public types and APIs** were simplified or left minimal (call out unnecessary breadth),
- approximate **net simplification** (lines/symbols) when practical,
- and any remaining follow-up work that is still justified.

For **review-only** output, include a short summary table or bullet list: finding, severity, location, suggested direction (not necessarily a full patch). Include rows for **dead code**, **spaghetti / complexity**, and **templates/styles/reuse** when HTML, CSS, or SCSS applies; include **API simplicity** when types or public contracts are in scope—even when the verdict is clean.

## Request Patterns

Treat requests like these as direct matches for this skill:

- "Review this for clarity, SOLID, and best practices."
- "Are the variable names and comments good enough here?"
- "Refactor this class without changing behavior."
- "Reduce duplication across these handlers."
- "Split this 300-line function into something maintainable."
- "Make this implementation cleaner and more concise."
- "Clean this module up before we add a new feature."
- "Find dead code and remove it."
- "This is spaghetti; simplify without changing behavior."
- "Net delete complexity; do not just wrap everything in new layers."
- "Clean up this template and SCSS; reuse what we already have."
- "Use nested SCSS and drop redundant classes."
- "Simplify this interface / public API; keep it generic and minimal."
