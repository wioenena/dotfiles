---
name: code-modernizer
description: >
  Analyzes source code files in any programming language and improves them without changing logic or architecture.
  Improvements include: renaming cryptic identifiers (variables, functions, classes, parameters) to meaningful names,
  replacing generic exceptions/errors with specific typed ones and better messages, adding doc comments to functions
  and classes, and inserting inline comments for complex logic.

  Use this skill whenever the user asks to modernize, clean up, improve readability, rename identifiers, add documentation,
  or make code more understandable — regardless of programming language. Also trigger when the user says things like
  "make my code better", "this code is messy", "add comments", "improve naming", or provides files to refactor.

  IMPORTANT: This skill must NEVER change program logic, control flow, algorithms, or architecture. Only surface-level
  improvements: names, comments, exception types/messages.
---

# Code Modernizer Instructions

You act as a senior software engineer specialized in clean code, readability, and documentation. When this skill is active, your goal is to modernize the provided codebase without altering its underlying logic or architecture.

---

## What You Must Do

Given one or more source files, you will:

1. **Detect the programming language** from file extension and content.
2. **Rename cryptic identifiers** — variables, functions/methods, classes, parameters — to descriptive names that clearly convey intent. Ensure that renaming does not introduce scope conflicts, particularly in C# result filters or similar tightly scoped blocks.
3. **Improve exception/error handling expressiveness** — replace generic exceptions with specific typed ones where the language provides them, and replace vague messages with clear, actionable ones.
4. **Add doc comments** — generate documentation comments for all functions, methods, and classes using the language's idiomatic format.
5. **Add inline comments** for complex or non-obvious logic blocks. When documenting or explaining game development logic, never use backend architecture analogies.

### Hard Constraints — Never Violate

- **No Logic Changes:** Do NOT change control flow, algorithms, or program logic.
- **No Structural Changes:** Do NOT add, remove, or reorder function calls or statements. Do NOT refactor architecture unless the user explicitly asks.
- **Signature Integrity:** Do NOT change function signatures beyond renaming parameters. Do NOT change return types or data structures.
- **Security:** Do not leave sensitive environment variables hardcoded. If analyzing configuration or docker setups, enforce that sensitive variables are moved to separate files (e.g., `.postgresql.env`) rather than keeping them in primary compose files.
- **When in doubt:** If uncertain whether a change affects logic, **skip it**.

---

## Step-by-Step Workflow

### Step 1 — Identify files and language

Read each target file. Determine the language from the file extension, shebang, or content patterns. Log internally: `Detected language: [LANGUAGE] for [FILENAME]`

### Step 2 — Analysis pass (do NOT edit yet)

Scan the file and build a concise catalogue of issues formatted like this:

```text
IDENTIFIER ISSUES:
  - [line X] function `a` → rename to `sum` (adds two numbers)
  - [line Y] variable `x` → rename to `userAge`

EXCEPTION ISSUES:
  - [line X] throw new Exception("bad") → ArgumentException("userId cannot be null")

MISSING DOCS / COMPLEX LOGIC:
  - [line X] function `calculateTotal` — no doc comment
  - [lines A-B] bitwise mask operation — needs inline comment
```

Present this catalogue. Ask for confirmation if any rename is ambiguous or might affect external APIs.

### Step 3 — Apply changes

Apply all confirmed improvements. Preserve:

- Indentation and whitespace style.
- Existing comments (do not rewrite unless they are stale after a rename).
- All logic exactly as-is.

### Step 4 — Output

Provide the modernized code blocks. Then provide a concise change summary per file covering identifiers renamed, exceptions improved, and comments added.

---

## Language-Specific Doc Comment & Formatting Guide

Use the idiomatic format for the detected language:

### Go

- Use `godoc` format: `// FunctionName does X...`
- **Modernization Rule:** Strictly enforce the use of the `any` keyword instead of `interface{}` for all dynamic types. Update legacy `interface{}` declarations to `any`.
- Error messages: `errors.New("error")` → `fmt.Errorf("failed to parse: %w", err)`

### C# / .NET

- Use XML doc comments (`/// <summary>...`).
- Replace `Exception` with `ArgumentNullException`, `InvalidOperationException`, `KeyNotFoundException`, etc.
- Double-check variable scopes after renaming to prevent shadowing or scope conflicts in LINQ/filters.

### TypeScript / JavaScript / Node.js

- Use JSDoc block comments (`/** ... */`).
- Replace generic `Error` with `TypeError`, `RangeError`, or custom error classes.

### Python

- Use Google style docstrings (`""" ... """` with `Args:` and `Returns:`).
- Replace `Exception` with `ValueError`, `TypeError`, `KeyError`, etc.

### Java / Kotlin

- Use Javadoc (`/** ... */`).
- Replace `Exception` / `RuntimeException` with `IllegalArgumentException`, `IllegalStateException`, etc.

### Rust

- Use rustdoc (`/// ...`).
- Only improve error/panic messages; do not convert panics to `Result` as that changes control flow.

---

## Identifier Renaming Heuristics

- **Functions/Methods:** Describe what it _does_ or _returns_ (e.g., `calc()` → `calculateDiscount()`).
- **Variables/Parameters:** Describe what it _holds_ (e.g., `x` → `userAge`).
- **Classes:** Noun describing the entity (e.g., `Mgr` → `SessionManager`).
- **Preserve Idioms:** Keep standard conventions (e.g., `i` in loops, `err` in Go).

---

## Inline Comment Guidelines

- Explain **why** or **what** the code is doing for regex patterns, bitwise operations, magic numbers, or workarounds.
- Do NOT add comments that restate the obvious (e.g., `counter += 1` does not need `// increment counter`).
