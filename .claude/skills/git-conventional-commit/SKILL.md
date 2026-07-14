---
name: git-conventional-commit
description: Analyzes staged/unstaged git changes and generates a Conventional Commits-compliant commit message in English. Use this skill whenever the user asks to "commit", "write a commit message", "generate a commit", mentions "conventional commits", or wants help summarizing git diffs into a commit. This skill NEVER pushes to any remote (no `git push`, `git push --force`, or any remote-mutating command) under any circumstances, even if explicitly asked — pushing is strictly out of scope and must be refused politely, pointing the user to run it themselves.
---

# Git Conventional Commit

This skill analyzes changes in a git repository and generates a commit message that strictly follows the **Conventional Commits** specification, always written in **English**. It may create a local commit, but it **never runs `git push`** under any circumstances.

## Hard Rules (never violated)

1. **Never push to a remote.** Do not run `git push`, `git push --force`, `git push origin ...`, or any other remote-mutating command. Even if the user explicitly asks for it, this is out of scope for this skill — politely explain that pushing is not something this skill does, and tell the user to run it themselves.
2. **Commit messages must always be in English**, regardless of the language used in the conversation, the codebase, or prior commit history.
3. **The commit message format must strictly follow Conventional Commits.** Never deviate from this template:
   ```
   <type>(<optional scope>): <description>

   [optional body]

   [optional footer(s)]
   ```
4. **Never run `git commit` without user confirmation.** Show the generated message first, get approval, then commit. If the user only asked for a message, don't commit at all — just produce the message.

## Workflow

### 1. Gather the Changes

```bash
git status --porcelain
git diff HEAD          # all staged + unstaged changes
git diff --staged      # only staged changes
```

- If there are no changes at all, tell the user and stop.
- If there are both staged and unstaged changes, clarify which set the commit message should cover (default: staged changes; if nothing is staged, analyze all changes and suggest running `git add`).
- If many/scattered files changed, review the diff file by file; optionally check `git log --oneline -10` for scope/style conventions already used in the project for consistency.

### 2. Analyze the Changes

From the diff, determine:

- **What changed** (new file, deleted file, logic change, formatting only, etc.)
- **Why it changed** (infer from function/file names and code context where possible)
- **Scope**: the affected module/package/directory (e.g. `api`, `auth`, `parser`, `riscord-gateway`). Leave the scope empty if the change affects the whole project.

### 3. Choose a Type

Pick exactly one Conventional Commits type:

| type       | When to use                                                                    |
| ---------- | ------------------------------------------------------------------------------ |
| `feat`     | A new feature was added                                                        |
| `fix`      | A bug fix                                                                      |
| `docs`     | Documentation-only changes                                                     |
| `style`    | Formatting changes that don't affect behavior (whitespace, semicolons, etc.)   |
| `refactor` | Code restructuring that is neither a bug fix nor a feature                     |
| `perf`     | A performance improvement                                                      |
| `test`     | Adding or fixing tests                                                         |
| `build`    | Changes to the build system or dependencies (npm, cargo, csproj, go.mod, etc.) |
| `ci`       | CI configuration/file changes                                                  |
| `chore`    | Other maintenance work (doesn't modify src or test files)                      |
| `revert`   | Reverts a previous commit                                                      |

If multiple types seem to apply, pick the most dominant/important change as the type, and explain the rest in the body if needed.

If there is a **breaking change**: append `!` right after the type/scope (e.g. `feat(api)!: ...`) AND add a `BREAKING CHANGE: <description>` line in the footer.

### 4. Write the Message (always in English)

- **Description**: imperative mood, lowercase start, no trailing period, short and specific (~50-72 characters target). E.g. `add rate limiting to auth middleware`.
- **Body** (optional, recommended for non-trivial changes): focuses on "why" rather than "what", bullet points if useful. Separated from the description by a blank line.
- **Footer** (optional): `BREAKING CHANGE: ...`, `Closes #123`, `Refs #456`, etc. Do NOT add any Co-Authored-By, Generated with, or other AI-attribution trailers — see Hard Rule 5.
- Always write the message in English — never switch to the conversation's language or the repository's existing commit language.
- Present the message inside a code block so the user can copy it directly.

### 5. Present and Confirm

Show the generated message and ask:

- Does the message look right, or should it be adjusted?
- Should this message be used to create a local commit now (`git commit -m "..."`)?

If the user confirms, run `git commit`. **Never suggest or run the push step** — after committing, just close with a short reminder like "Committed locally — push whenever you're ready, that step is on you."

## Example Output

```
feat(auth): add JWT refresh token rotation

Previously refresh tokens were static until expiry, allowing replay
if leaked. Now each refresh issues a new token and invalidates the
old one.

Closes #142
```

## Edge Cases

- **During a merge commit / rebase**: don't use this skill, don't touch git's own automatic message.
- **Only `.gitignore`, whitespace-only, or lockfile-only changes**: usually `chore` or `build` (for lockfiles) is appropriate.
- **Large/mixed diff (multiple unrelated logical changes)**: suggest the user split it into separate commits (`git add -p`) instead of generating one convoluted message.
- **Any remote-related command is requested** (`push`, `push --tags`, `push --force`, etc.): politely refuse, explain why, and suggest the user run it themselves.
