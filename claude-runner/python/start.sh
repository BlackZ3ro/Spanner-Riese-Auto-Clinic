#!/bin/sh
set -e
PROMPT="${1:-Write a short update for the repo documentation about the current project status.}"
python app.py "$PROMPT"

if [ -n "$GITHUB_TOKEN" ]; then
  BRANCH="${GITHUB_BRANCH:-claude/runner}"
  REPO="${GITHUB_REPO:-BlackZ3ro/Spanner-Riese-Auto-Clinic}"
  git config --global user.email "claude-runner@example.com"
  git config --global user.name "claude-runner"
  git init
  git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO}.git"
  git checkout -b "$BRANCH"
  git add claude_output.md || true
  if git diff --cached --quiet; then
    echo "No changes to commit"
  else
    git commit -m "chore: update claude output"
    git push --set-upstream origin "$BRANCH"
  fi
fi
