#!/usr/bin/env bash
#
# Check pinned CLI tool versions against their upstream latest releases.
#
# This script powers the "Check for updates" step of the Dependency Version
# Check workflow, but is designed to run locally too so you can verify it works
# before pushing.
#
# Behaviour:
#   - Compares each pinned version (extracted from repo files) with the latest
#     upstream version (npm / GitHub releases / PyPI).
#   - Prints a human-readable summary to stdout.
#   - When updates are found, writes a Markdown issue body to ISSUE_BODY_FILE
#     (default: a temp file) and prints it.
#   - In CI (when GITHUB_OUTPUT is set) exposes `has_updates=true|false`.
#
# Requirements: bash, grep (PCRE / -P), curl, jq, gh (authenticated), npm.
#
# Usage:
#   ./scripts/check-dependency-updates.sh
#
# Environment overrides:
#   ISSUE_BODY_FILE   Path to write the Markdown issue body (default: mktemp).
#   GITHUB_OUTPUT     If set, `has_updates` is appended (CI behaviour).
#   GITHUB_SERVER_URL Base URL for the workflow link (default: https://github.com).
#   GITHUB_REPOSITORY owner/repo for the workflow link (default: derived from git remote).

set -euo pipefail

# --- Locate repo root so relative file paths resolve regardless of CWD --------
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)
REPO_ROOT=$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)
cd "${REPO_ROOT}"

# --- CI / local environment defaults -----------------------------------------
GITHUB_SERVER_URL="${GITHUB_SERVER_URL:-https://github.com}"
if [ -z "${GITHUB_REPOSITORY:-}" ]; then
  # Best-effort derivation of owner/repo from the origin remote for local runs.
  # Handles https://, git@github.com:, and custom SSH host aliases.
  GITHUB_REPOSITORY=$(git config --get remote.origin.url 2>/dev/null \
    | sed -E 's#\.git$##; s#.*[:/]([^/]+/[^/]+)$#\1#' || true)
fi
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-unknown/unknown}"

ISSUE_BODY_FILE="${ISSUE_BODY_FILE:-$(mktemp)}"

UPDATES=""
HAS_UPDATES="false"

# warn: emit a GitHub Actions annotation in CI, a plain message locally.
warn() {
  if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "::warning::$1"
  else
    echo "WARNING: $1" >&2
  fi
}

# extract_pinned: read a pinned version via grep without aborting on no match.
extract_pinned() {
  local name="$1" pattern="$2" file="$3" value
  if [ ! -f "$file" ]; then
    warn "File not found for $name: $file"
    return
  fi
  value=$(grep -oP "$pattern" "$file" || true)
  if [ -z "$value" ]; then
    warn "Failed to extract pinned version for $name from $file"
  fi
  printf '%s' "$value"
}

# check_tool: compare pinned vs latest and record updates.
check_tool() {
  local name="$1" pinned="$2" latest="$3" link="$4"
  if [ -z "$pinned" ]; then
    # extract_pinned already warned; skip comparison.
    return
  fi
  if [ -z "$latest" ]; then
    warn "Failed to fetch latest version for $name"
    return
  fi
  if [ "$pinned" != "$latest" ]; then
    UPDATES+="| $name | $pinned | $latest | $link |\n"
    HAS_UPDATES="true"
    echo "$name update available: $pinned -> $latest"
  else
    echo "$name is up to date ($pinned)"
  fi
}

# =============================================
# CLI Tools (versions extracted from repo files)
# =============================================

# --- markdownlint-cli2 (npm) ---
PINNED=$(extract_pinned "markdownlint-cli2" 'markdownlint-cli2@\K[0-9.]+' actions/markdownlint/action.yaml)
LATEST=$(npm view markdownlint-cli2 version 2>/dev/null || true)
check_tool "markdownlint-cli2" "$PINNED" "$LATEST" "[npm](https://www.npmjs.com/package/markdownlint-cli2)"

# --- git-cliff (GitHub releases) ---
PINNED=$(extract_pinned "git-cliff" 'VERSION="\K[0-9.]+' actions/git-cliff/action.yaml)
LATEST=$(gh release view --repo orhun/git-cliff --json tagName -q .tagName | sed 's/^v//')
check_tool "git-cliff" "$PINNED" "$LATEST" "[GitHub](https://github.com/orhun/git-cliff/releases)"

# --- actionlint (GitHub releases) ---
PINNED=$(extract_pinned "actionlint" 'download-actionlint\.bash\) \K[0-9.]+' .github/workflows/workflow-lint.yaml)
LATEST=$(gh release view --repo rhysd/actionlint --json tagName -q .tagName | sed 's/^v//')
check_tool "actionlint" "$PINNED" "$LATEST" "[GitHub](https://github.com/rhysd/actionlint/releases)"

# --- zizmor (PyPI) ---
PINNED=$(extract_pinned "zizmor" 'zizmor==\K[0-9.]+' .github/workflows/workflow-lint.yaml)
LATEST=$(curl -s https://pypi.org/pypi/zizmor/json | jq -r .info.version)
check_tool "zizmor" "$PINNED" "$LATEST" "[PyPI](https://pypi.org/project/zizmor/)"

# --- grant (GitHub releases) ---
PINNED=$(extract_pinned "grant" 'VERSION="\K[0-9.]+' actions/grant-check/action.yaml)
LATEST=$(gh release view --repo anchore/grant --json tagName -q .tagName | sed 's/^v//')
check_tool "grant" "$PINNED" "$LATEST" "[GitHub](https://github.com/anchore/grant/releases)"

# --- Expose result to CI ------------------------------------------------------
if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "has_updates=$HAS_UPDATES" >> "$GITHUB_OUTPUT"
fi

# --- Build the issue body when updates are found ------------------------------
if [ "$HAS_UPDATES" = "true" ]; then
  {
    echo "The following pinned dependencies have newer versions available:"
    echo ""
    echo "| Dependency | Pinned | Latest | Link |"
    echo "|------------|--------|--------|------|"
    echo -e "$UPDATES"
    echo "Review the changelogs and update the pinned versions if appropriate."
    echo ""
    echo "_Automatically created by the [Dependency Version Check](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/workflows/dependency-version-check.yaml) workflow._"
  } > "$ISSUE_BODY_FILE"

  echo ""
  echo "Updates found. Issue body written to: $ISSUE_BODY_FILE"
  echo "----------------------------------------------------------------------"
  cat "$ISSUE_BODY_FILE"
else
  echo ""
  echo "All tracked dependencies are up to date."
fi
