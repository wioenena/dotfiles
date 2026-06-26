---
name: git-commit
description: Create properly formatted Git conventional commits with automatic type detection from diffs. Analyzes code changes, suggests commit type (feat, fix, refactor, etc.), and guides you interactively through the commit process with required scope and optional body/footer. Uses only git commands—no external scripts. ONLY commits locally, NEVER pushes to remote. Use this whenever you need to make a commit, especially for consistent semantic messages. Trigger on "commit my changes", "git commit", "make a commit", or when wanting structured conventional commits.
---

# Conventional Commit Assistant

Creates semantically meaningful Git commits following the [Conventional Commits](https://www.conventionalcommits.org/) specification. Runs entirely through git commands—no external tools or scripts.

## How it works

1. **Examines staged & unstaged changes** — Uses `git diff` and `git status`
2. **Suggests commit type** — Based on file patterns and changes
3. **Asks for required scope** — E.g., `auth`, `api`, `db`, `ui`
4. **Gathers commit subject** — First-line summary (50 chars max)
5. **Optional body & footer** — Detailed explanation and breaking changes
6. **Previews full message** — Shows formatted commit before confirming
7. **Commits locally** — Uses only `git commit`, **never pushes**

## Workflow

### Step 1: Check status

I'll run:
```bash
git status
git diff --cached
git diff
```

This shows what's staged, unstaged, and suggests a type:
- **New files** → `feat` 
- **Bug fixes** → `fix`
- **Refactoring** → `refactor`
- **Test files** → `test`
- **Docs only** → `docs`
- **Build/config** → `chore`

### Step 2: Handle staging

If you have unstaged changes, I ask:
- **Stage all?** Add everything to the staging area
- **Commit only staged?** Keep unstaged separate

### Step 3: Confirm or change type

I suggest a type. You can:
- ✅ Accept it
- ↩️ Pick a different one

### Step 4: Collect details

Prompts for (in order):
1. **Scope** (required) — `auth`, `api`, `payments`, etc.
2. **Subject** (required) — What changed, ≤50 chars
3. **Body** (optional) — Why and how
4. **Footer** (optional) — Breaking changes or issue refs

### Step 5: Preview & confirm

You see the formatted message:
```
feat(auth): implement JWT refresh mechanism

Add automatic token refresh to improve UX.
Silently refresh before expiry.

BREAKING CHANGE: logout endpoint returns 204 instead of 200
Closes #456
```

Confirm: `y` to commit, `n` to revise.

### Step 6: Create commit

I run:
```bash
git commit -m "feat(auth): implement JWT refresh mechanism" \
  -m "body text here" \
  -m "footer text here"
```

**Done. No push. No remote changes.**

## Commit Types

| Type | Use for |
|------|---------|
| `feat` | New functionality or features |
| `fix` | Bug fixes |
| `refactor` | Code restructuring (same behavior) |
| `perf` | Performance improvements |
| `style` | Formatting, linting (no logic) |
| `test` | Adding/updating tests |
| `docs` | Documentation changes |
| `chore` | Build, deps, tooling |
| `ci` | CI/CD configuration |
| `revert` | Reverting a previous commit |

## Scope examples

✅ **Good:**
- `auth`
- `api`
- `db-migration`
- `ui-button`
- `payment-processor`

❌ **Avoid:**
- Empty scope
- `features`, `bugfix` (too generic)
- Uppercase

## Safety guarantees

- ✅ **Local only** — Commits stay in your repo
- ✅ **No auto-push** — You control pushing
- ✅ **Always preview** — See full message before commit
- ✅ **No --force** — Won't override commits
- ✅ **Git native** — Uses only git commands

## Tips

- Keep subject under 50 characters
- Body explains *why*, not *what*
- Use `Closes #123` to link issues
- Use `BREAKING CHANGE:` prefix for non-backward-compatible changes
- Body and footer are wrapped at ~72 characters automatically by git
