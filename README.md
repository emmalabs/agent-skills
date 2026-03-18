# Agent Skills

Shared Codex skills for Emma Labs workflows.

This repository is the versioned source of truth for custom skills that should work across repositories and across developer machines.

## What Goes Here

- Reusable Codex skills that apply in more than one repository
- Team workflows that should not live only in a local `$CODEX_HOME`
- Skill metadata needed for Codex to discover and invoke the skill

Repository-specific rules should stay in each repository's `AGENTS.md`.

## Current Skills

### `linear-implement-issue`

Implements a Linear issue end to end:

- reads the issue through Linear MCP
- moves the issue to `In Progress` when coding starts
- implements and validates the change
- opens a pull request to `develop`
- adds the pull request back to the Linear issue
- moves the issue to `In Review` when ready

Files:

- [linear-implement-issue/SKILL.md](/home/aleix/Projects/agent-skills/linear-implement-issue/SKILL.md)
- [linear-implement-issue/agents/openai.yaml](/home/aleix/Projects/agent-skills/linear-implement-issue/agents/openai.yaml)

## Setup

Clone this repository on each machine:

```bash
git clone git@github.com:emmalabs/agent-skills.git ~/Projects/agent-skills
```

Then make the skill available to Codex from `$CODEX_HOME/skills`.

### Option 0: symlink via script (recommended)

This repo includes an idempotent helper that creates/updates the symlink(s) under `$CODEX_HOME/skills` (defaulting to `~/.codex`):

```bash
cd ~/Projects/agent-skills
./create-codex-symlinks.sh
```

### Option 1: symlink individual skills

```bash
mkdir -p "$CODEX_HOME/skills"
ln -s ~/Projects/agent-skills/linear-implement-issue "$CODEX_HOME/skills/linear-implement-issue"
```

Option 2: copy the skill folder

```bash
mkdir -p "$CODEX_HOME/skills"
cp -R ~/Projects/agent-skills/linear-implement-issue "$CODEX_HOME/skills/"
```

Symlinks are preferred because updates in this repository are reflected immediately.

## How To Use

Once the skill is available in `$CODEX_HOME/skills`, trigger it explicitly or by asking for the workflow in natural language.

Examples:

```text
Use $linear-implement-issue to implement this ticket: ENG-123
```

```text
Implement this Linear issue and open the PR to develop: https://linear.app/.../ENG-123/...
```

For the `linear-implement-issue` skill to work, Linear MCP must already be connected and authenticated in Codex.

## Repository Integration

Each application repository should keep a short rule in its `AGENTS.md` pointing to the shared skill, for example:

```md
## Linear Workflow

- For implementation work driven by a Linear issue, use the shared `$linear-implement-issue` skill.
```

This keeps the detailed workflow centralized here while preserving repo-local guidance.

## Adding A New Skill

1. Create a new folder using a lowercase hyphenated name.
2. Add a `SKILL.md` with accurate trigger guidance.
3. Add `agents/openai.yaml` so the skill is visible in the UI.
4. Validate the skill before committing.
5. Add a short section here describing what the skill does and when to use it.

Validation example:

```bash
python3 /mnt/c/Users/aleix/.codex/skills/.system/skill-creator/scripts/quick_validate.py ~/Projects/agent-skills/<skill-name>
```

## Conventions

- Keep skills reusable across repositories.
- Keep `SKILL.md` focused on workflow instructions.
- Avoid putting business process details only in a local machine config.
- Prefer updating an existing shared skill over duplicating similar skills.
- If a workflow is repo-specific, keep the full rule in that repo instead of adding it here.
