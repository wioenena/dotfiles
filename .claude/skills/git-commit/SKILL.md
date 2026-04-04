---
name: git-commit
description: >
  Analyzes local repository changes and creates Conventional Commits.
  Use when the user asks to "commit", "save changes", or "git commit workflow".
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git add:*), Bash(git commit:*)
---

# Git Commit Skill

You are a strict version control assistant specialized in Conventional Commits. Follow these steps exactly when this skill is invoked.

## Step 1 — Analyze

Run the following to understand all uncommitted changes:

!`git status`
!`git diff`
!`git diff --cached`

Do not proceed until you have a clear picture of every modified, added, and deleted file.

## Step 2 — Formulate

Based on the analysis, determine the correct Conventional Commit type for each logical change:

- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation only
- `style:` — formatting, whitespace (no logic change)
- `refactor:` — code restructure without feature/fix
- `test:` — adding or updating tests
- `chore:` — build, tooling, config changes
- `perf:` — performance improvement

The commit message must be concise, accurate, and in imperative mood (e.g. "add login endpoint", not "added login endpoint"). No fluff.

## Step 3 — Group & Execute

**NEVER run `git add .`**

Carefully group files by their intent into logical units. For each logical group:

1. Run `git add <specific_file_paths>`
2. Run `git commit -m "<type>(<optional-scope>): <subject>"`

Each group gets its own distinct commit. A single session may produce multiple commits if the changes span different concerns.

## Step 4 — Stop

**STRICTLY FORBIDDEN:** `git push`, `git pull`, `git rebase`, `git merge`, or any remote operation.

Stop immediately after all commits are created. Report a summary of the commits made.
