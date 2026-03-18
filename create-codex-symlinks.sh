#!/usr/bin/env bash
set -euo pipefail

# Creates symlinks for this repo's Codex skills into $CODEX_HOME/skills.
# Re-runnable: it updates existing symlinks/directories safely.

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="${CODEX_HOME}/skills"

# Repo root (this script lives at the repo root).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "${SKILLS_DIR}"

link_skill() {
  local name="$1"
  local src="${REPO_ROOT}/${name}"
  local dst="${SKILLS_DIR}/${name}"

  if [[ ! -e "${src}" ]]; then
    echo "Source missing, skipping: ${src}"
    return 0
  fi

  if [[ -L "${dst}" ]]; then
    # If it's already the right target, do nothing.
    local current
    current="$(readlink "${dst}")"
    if [[ "${current}" == "${src}" ]]; then
      echo "Symlink already correct: ${dst} -> ${src}"
      return 0
    fi
    echo "Updating symlink: ${dst} (was -> ${current})"
    rm -f "${dst}"
  elif [[ -e "${dst}" ]]; then
    # Destination exists but isn't the expected symlink.
    echo "Destination exists and is not a symlink: ${dst}"
    echo "Refusing to overwrite. Please move/remove it and re-run."
    exit 1
  fi

  ln -s "${src}" "${dst}"
  echo "Created symlink: ${dst} -> ${src}"
}

link_skill "linear-implement-issue"

echo "Done. Codex skills are available in: ${SKILLS_DIR}"

