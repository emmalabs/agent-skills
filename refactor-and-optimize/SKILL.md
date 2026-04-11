---
name: refactor-and-optimize
description: "Guide for code review and safe refactors across backend, frontend, scripts, and libraries. Use when improving clarity, structure, and maintainability: apply SOLID and common best practices, meaningful naming, proportionate comments, deduplication, and smaller modules or functions without changing behavior. Use for requests to review code, suggest improvements, or refactor safely. Do not use this skill for runtime, product, query, or rendering performance tuning."
---

# Refactor And Optimize

## Overview

Use this skill to turn vague requests like "clean this up" or "make this more concise" into a small, testable change set with clear behavioral guardrails. Prefer simpler structure, less duplication, and clearer code over broader rewrites or performance work.

When the user asks for a **review** (not an immediate refactor), produce a structured assessment first: strengths, issues grouped by severity (must-fix vs nice-to-have), and concrete suggestions tied to line or symbol references. Offer to implement after alignment unless they asked for changes outright.

## Design principles (clarity, SOLID, practices)

Use these as a checklist while reviewing or refactoring. Prefer practical judgment over dogma; one clear module beats five tiny ones that obscure the flow.

- **Single responsibility**: each unit (function, type, module) should have one obvious reason to change; split when multiple concerns evolve on different schedules.
- **Open/closed**: favor composition and small extension points over editing the same giant conditional for every new case.
- **Liskov substitution**: subtypes must honor the contract of the base type or interface (invariants, errors, nullability); avoid surprises for callers.
- **Interface segregation**: depend on narrow types or APIs; avoid forcing callers to depend on methods they do not use.
- **Dependency inversion**: depend on abstractions at boundaries (ports); keep domain logic free of incidental infrastructure when it improves testability and clarity.
- **Readability**: explicit data flow, shallow nesting, guard clauses over deep else trees, and domain vocabulary in names.
- **Consistency**: match existing project patterns (error style, async patterns, layering); read `AGENTS.md` or local conventions when present.

## Naming and comments

- **Names**: prefer full words and domain terms from the codebase; avoid unexplained abbreviations and single-letter names except tight local scope (indices, coordinates). Booleans: `is`/`has`/`can`/`should` prefixes where it reads naturally. Functions are verbs; types are nouns. Rename in dedicated commits or steps when mixed with logic changes.
- **Comments**: add short comments where intent, preconditions, invariants, or non-obvious "why" would otherwise be lost; do not narrate what the next line obviously does. After refactors, update or remove stale comments. If the repository documents a comment style (for example prefer labeling blocks), follow it.

## Workflow

### 1. Frame the task precisely

Classify the request before editing:

- `Review`: assess clarity, SOLID alignment, naming, comments, duplication, and risks; optionally implement fixes in a follow-up.
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

### 3. Protect behavior before editing

Preserve validation integrity:

- Reuse existing tests when they already pin behavior.
- Add a focused characterization test when behavior is implicit or fragile.
- Keep API shape, side effects, error handling, and ordering stable unless the user asked to change them.
- Avoid mixing semantic changes into a refactor unless the task explicitly requires it.

### 4. Choose the smallest high-value change

Prefer the simplest change that removes the main source of complexity or waste:

- extract a pure helper before inventing a new abstraction,
- remove duplication only when the shared behavior is truly stable,
- collapse indirection when wrappers add no policy,
- prefer direct data flow over layered ceremony,
- simplify repeated conditionals, mapping, and validation paths before introducing new utilities.

Read [references/heuristics.md](references/heuristics.md) when the right refactor shape or optimization target is not obvious.

### 5. Edit incrementally

Make changes in narrow slices that are easy to reason about and validate:

- separate naming/moves from logic changes when possible,
- keep public entry points stable while rewriting internals,
- prefer deleting code over adding coordination layers,
- leave brief comments only where the new shape would otherwise be hard to follow.

### 6. Validate from narrow to broad

Run the smallest trustworthy checks first, then widen only as needed:

- targeted tests for touched behavior,
- lint or type checks for the changed surface,
- broader suites only when the risk or blast radius justifies the time.

If the code is not meaningfully clearer or smaller after the change, say so plainly instead of claiming an improvement.

### 7. Report the outcome clearly

Summarize the result in terms of:

- what changed structurally,
- what stayed behaviorally stable,
- what duplication, clutter, or indirection was removed,
- naming or comment improvements when relevant,
- and any remaining follow-up work that is still justified.

For **review-only** output, include a short summary table or bullet list: finding, severity, location, suggested direction (not necessarily a full patch).

## Request Patterns

Treat requests like these as direct matches for this skill:

- "Review this for clarity, SOLID, and best practices."
- "Are the variable names and comments good enough here?"
- "Refactor this class without changing behavior."
- "Reduce duplication across these handlers."
- "Split this 300-line function into something maintainable."
- "Make this implementation cleaner and more concise."
- "Clean this module up before we add a new feature."
