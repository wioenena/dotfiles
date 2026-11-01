---
name: git-commit
description: Writes professional, English Conventional Commits messages (feat/fix/refactor/docs/chore..., scope, imperative subject, explanatory body, BREAKING CHANGE and issue footers) by reading the actual git diff, proposes them to the user, and runs `git commit` after approval. Splits unrelated changes into separate commits. Use this skill whenever the user wants to commit, asks for a commit message, says things like "commit at", "commit mesajı yaz", "değişiklikleri commitle", "write a commit message", "commit this", "git commit", or finishes a piece of work and wants to save it to git — even if they don't mention Conventional Commits or the word "professional".
---

# Git Commit

Produce commit messages that a senior engineer reviewing the history a year from now would be glad to read: accurate to the diff, consistent with the repo, and explaining _why_ the change was made — not just _what_ lines moved.

Messages are always in **English** and follow **Conventional Commits 1.0**, even when the user talks to you in Turkish or another language. Talk to the user in their own language; only the commit message itself is English.

## Workflow

### 1. Look at what actually changed

Run these (in parallel where possible):

```
git status --short
git diff --staged
git diff
git log -n 15 --pretty=format:"%s"
```

- Base the message on the diff, not on what the user _says_ changed or on file names alone. If the user's description and the diff disagree, trust the diff and mention the discrepancy.
- `git log` tells you the repo's habits: which scopes are used (`api`, `auth`, `ui`...), whether a ticket prefix is expected, whether bodies are written. Match existing conventions where they don't conflict with Conventional Commits — a consistent history is more valuable than your personal preference.
- For large diffs, use `git diff --staged --stat` first and then read the most important files rather than skimming everything superficially.

**What to commit:**

- If something is staged, the staged changes are the commit. Don't stage extra files without asking.
- If nothing is staged, propose which files to stage (normally all the related modified files). Never stage things that look like secrets (`.env`, credentials, keys) or junk (build output, `node_modules`, OS files) — point them out instead.
- If there are no changes at all, say so and stop.

### 2. Decide whether it is one commit or several

A commit should be one logical change — something that could be reverted on its own. If the diff mixes unrelated work (e.g. a bug fix plus an unrelated README edit, or a feature plus a mass reformat), propose splitting it into separate commits, each with its own message and file list. Split by file when possible; if one file contains both kinds of change, mention it and let the user decide rather than doing fiddly partial staging silently.

Don't over-split: a feature and its tests and docs belong together.

### 3. Write the message

```
<type>(<scope>)<!>: <subject>

<body>

<footer(s)>
```

**Type** — pick by the _effect_ of the change:

| type       | use for                                      |
| ---------- | -------------------------------------------- |
| `feat`     | new user-facing capability                   |
| `fix`      | bug fix                                      |
| `perf`     | performance improvement, no behaviour change |
| `refactor` | code restructuring, no behaviour change      |
| `docs`     | documentation only                           |
| `test`     | adding/fixing tests only                     |
| `style`    | formatting, whitespace, no logic change      |
| `build`    | build system, dependencies                   |
| `ci`       | CI configuration                             |
| `chore`    | maintenance that fits nothing above          |
| `revert`   | reverting a previous commit                  |

**Scope** — optional, short noun for the affected area (`auth`, `api`, `parser`). Prefer scopes already used in `git log`. Omit it rather than inventing a vague one like `misc` or `code`.

**Subject**

- Imperative mood, as if completing "If applied, this commit will ___": `add`, `fix`, `remove` — not `added`, `adds`, `adding`.
- Lowercase first letter, no trailing period.
- Aim for ≤ 50 characters for the whole first line; never exceed 72.
- Specific: `fix(cart): prevent negative item quantities` beats `fix: fix bug`. Avoid empty words like "update", "changes", "stuff", "some fixes" unless nothing more precise is true.

**Body** — include it unless the change is truly trivial (typo, version bump). Separate from the subject with a blank line, wrap at 72 characters.

- Explain the motivation and the problem being solved, and anything non-obvious about the approach (trade-offs, why not the obvious alternative).
- Don't narrate the diff file by file; the diff already shows that. Bullet points are fine for several distinct changes.
- Only state things the diff or the user supports. Don't invent motivations, ticket numbers, or test results.

**Footers**

- Breaking change (removed/renamed public API, changed config format, changed default behaviour callers rely on): add `!` after the type/scope **and** a `BREAKING CHANGE: <what breaks and how to migrate>` footer.
- Issue references the user mentions: `Closes #42`, `Refs #17`. Use what the user gave you; don't make them up.
- Follow any trailer convention visible in the repo (e.g. `Signed-off-by`) if present.

### 4. Propose, then commit

Show the user:

- the file(s) that will be committed (and anything you're deliberately leaving out, with the reason),
- the full commit message in a code block,
- if splitting, each commit in order.

Then ask for approval (in the user's language). Accept edits and adjust. Do not run `git commit` before the user approves — they may want to tweak wording or the file set, and an unwanted commit is annoying to undo.

After approval, commit by writing the message to a temporary file and using `git commit -F <file>`. This preserves the blank lines and line breaks of a multi-line message reliably on every shell (PowerShell, bash, cmd), unlike stacking `-m` flags or inline quoting. Put the file inside the repo's own `.git/` directory with a unique name (e.g. `.git/CLAUDE_COMMIT_MSG_<timestamp>`): a generic name in a shared temp folder can be overwritten by another process between writing and committing, which produces a commit with the wrong message. Delete the temp file afterwards, and check with `git log -1` that the committed message is the one the user approved.

Finish by running `git log -n <count> --stat` (or `git show --stat HEAD`) and briefly confirming what was committed. Never push unless the user explicitly asks.

## Examples

**Small feature, repo uses scopes**

```
feat(auth): add password reset via email

Users who forgot their password had no way to recover their account
without contacting support. Add a /password-reset endpoint that emails
a single-use token valid for 30 minutes.
```

**Bug fix with issue reference**

```
fix(cart): prevent negative item quantities

Decrementing an item with quantity 1 produced -1 instead of removing
it, which broke the order total. Remove the item when quantity reaches
zero.

Closes #128
```

**Breaking change**

```
refactor(api)!: rename getUser to fetchUser and return a Promise

The synchronous getUser blocked the event loop on slow databases.

BREAKING CHANGE: getUser() is removed. Use `await fetchUser(id)`
instead; it now returns Promise<User | null>.
```

**Trivial change — subject only**

```
docs: fix typo in installation guide
```
