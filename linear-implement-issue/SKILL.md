---
name: linear-implement-issue
description: Use when the user wants to implement a Linear issue from a Linear link or issue identifier. Read the issue with the Linear MCP, move it to In Progress when implementation starts, complete the code changes in the target repository, open a pull request to the develop branch, add that pull request back to the Linear issue, and move the issue to In Review when finished.
---

# Linear Implement Issue

## Overview

This skill handles the full execution flow for a Linear-driven implementation task. Use it when the user sends a Linear issue link or issue identifier and expects the issue to be implemented, status-managed in Linear, and prepared for review with a PR to `develop`.

## Workflow

1. Identify the issue.
   Accept either a Linear issue URL or an issue identifier such as `ENG-123`. Extract the identifier before calling Linear tools.

2. Read the issue with Linear MCP.
   Use the `linear` skill workflow and start with read operations:
   - `mcp__linear__get_issue`
   - `mcp__linear__list_comments` when comments are needed for implementation context
   - `mcp__linear__get_project` or `mcp__linear__get_team` only if the issue needs extra project context

3. Confirm the working repository from local context.
   Inspect the current repository before editing. Do not assume the issue belongs to the current folder unless the repo context supports it.

4. Move the issue to `In Progress` when implementation starts.
   Change the Linear issue state immediately before the first code edit, not earlier during pure investigation.

5. Implement the change end to end.
   Read the relevant code, make the changes, and run the most relevant validation available for that repository.

6. Prepare the branch and PR.
   Use a non-interactive git workflow.
   - Create or reuse a working branch with the `codex/` prefix when a new branch is needed.
   - Push the branch if the remote is available.
   - Open a pull request targeting `develop`.
   - Add the PR URL to the Linear issue once the PR exists. Prefer attaching it directly to the issue with the Linear MCP issue update tools.
   - Include the Linear issue identifier in the branch, commit, or PR body when it fits the repo conventions.

7. Move the issue to `In Review` after implementation is complete.
   Do this after local validation succeeds, the PR is opened, and the PR is attached to the Linear issue, or after the code is otherwise ready for review if PR creation is blocked.

8. Report the outcome.
   In the final handoff, include:
   - what was changed
   - what validation ran
   - the Linear status transition
   - the PR link, or the concrete reason a PR could not be created

## Operational Rules

- Use Linear MCP as the source of truth for the issue state and description.
- When a PR is created, add it to the Linear issue before moving the issue to `In Review`.
- If Linear MCP access is unavailable, stop before code changes and report the blocker.
- If the target repository is not a git repository, or PR creation is not possible because remote/auth is missing, still complete the implementation when possible and state the exact blocker.
- Do not skip the status transitions unless the user explicitly asks you not to update Linear.
- Prefer the repository's existing `AGENTS.md` guidance for testing, formatting, comments, and commit conventions.
- Do not use interactive git commands.

## Typical Trigger Phrases

- "Implement this Linear issue"
- "Here is the Linear ticket, start working on it"
- "Take this issue from Linear and open the PR"
- A message containing only a Linear issue URL plus an instruction to build or fix it
